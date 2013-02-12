# [SWFService](http://github.com/CodeCatalyst/SWFService) v2.0
# Copyright (c) 2008-2013 [CodeCatalyst, LLC](http://www.codecatalyst.com/).
# Open source under the [MIT License](http://en.wikipedia.org/wiki/MIT_License).

class Timer
	constructor: ( duration ) ->
		now = -> new Date().getTime()
		start = now()
		
		@elapsed = -> 
			return now() - start
		
		@remaining = -> 
			return Math.max( duration - @elapsed(), 0 )
		
		@expired = -> 
			return @elapsed() > duration

class EntitySet
	constructor: ( @entityClass, @entityKeyProperty = 'id' ) ->
		@entitiesByKey = {}
	
	add: ( entity ) ->
		if ! ( entity instanceof @entityClass )
			throw new Error( "Entity must be of type: #{ @entityClass.name } to be added to this EntitySet." )
		
		entityKey = entity[ @entityKeyProperty ]
		if @exists( entityKey )
			throw new Error( "An Entity with key: #{ entityKey } already exists in this EntitySet." )
		@entitiesByKey[ entityKey ] = entity
		return entity
	
	remove: ( entity ) ->
		if @contains( entity )
			delete @entitiesByKey[ entity[ @entityKeyProperty ] ]
			return entity
		return null
	
	removeAll: ->
		@entitiesByKey = {}
		return
	
	get: ( key ) ->
		return @entitiesByKey[ key ]
	
	find: ( attributes ) ->
		matches = ( entity ) ->
			for attribute, attributeValue of attributes
				if entity[ attribute ] isnt attributeValue
					return false
			return true
		return @match( matches )
		
	match: ( matcherFunction ) ->
		matchingEntities = []
		for entityId, entity of @entitiesByKey
			if matcherFunction( entity )
				matchingEntities.push( entity )
		return matchingEntities
	
	contains: ( entity ) ->
		entityKey = entity[ @entityKeyProperty ]
		return @exists( entityKey ) and entity is @get( entityKey )
	
	exists: ( key ) ->
		return @entitiesByKey[ key ]?
	
	toArray: ->
		entities = []
		for entityId, entity of @entitiesByKey
			entities.push( entity )
		return entities

class DeferredEntityRegistry
	constructor: ( @entityClass, @entityKeyProperty = 'id' ) ->
		@entities = new EntitySet( @entityClass )
		@pendingEntityRequestsByEntityId = {}
	
	get: ( entityId, timeout ) ->
		entity = @entities.get( entityId )
		if entity?
			deferred = new Deferred()
			deferred.resolve( entity )
			return deferred.promise
		else
			deferred = new Deferred()
			if timeout?
				setTimeout( 
					=>
						deferred.reject( new Error( "Request for #{ @entityClass.name } with #{ @entityKeyProperty }: \"#{ entityId }\" timed out." ) )
						return
					timeout
				)
			@pendingEntityRequestsByEntityId[ entityId ] ?= []
			@pendingEntityRequestsByEntityId[ entityId ].push( deferred )
			return deferred.promise
	
	register: ( entity ) ->
		@entities.add( entity )
		entityId = entity[ @entityKeyProperty ]
		pendingEntityRequests = @pendingEntityRequestsByEntityId[ entityId ]
		for pendingEntityRequest in pendingEntityRequests
			pendingEntityRequest.resolve( entity )
		delete @pendingEntityRequestsByEntityId[ entityId ]
		return entity
	
	unregister: ( entity ) ->
		@entities.remove( entity )
		return entity

class SWFServiceProxy
	constructor: ( serviceContext, @id, descriptor ) ->
		createGetter = ( propertyName ) ->
			return -> 
				return serviceContext.getServiceProperty( id, propertyName )
		createSetter = ( propertyName ) ->
			return ( value ) -> 
				serviceContext.setServiceProperty( id, propertyName, value )
				return
		createMethod = ( methodName ) ->
			return -> 
				args = Array.prototype.slice.call( arguments )
				return serviceContext.executeServiceMethod( id, methodName, args )
		
		for accessor in descriptor.accessors
			Object.defineProperty( @, accessor.name, 
				writeable: accessor.access isnt 'readonly'
				get: createGetter( accessor.name )
				set: createSetter( accessor.name )
			)
		for variable in descriptor.variables
			Object.defineProperty( @, variable.name, 
				get: createGetter( variable.name )
				set: createSetter( variable.name )
			)
		for method in descriptor.methods
			@[ method.name ] = createMethod( method.name )
		
		if descriptor.isEventDispatcher
			@addEventListener = ( eventType, listenerFunction, useCapture = false, priority = 0, weakReference = false ) ->
				serviceContext.addServiceEventListener( id, eventType, listenerFunction, useCapture, priority, weakReference )
				return
			@removeEventListener = ( eventType, listenerFunction, useCapture = false ) ->
				serviceContext.removeServiceEventListener( id, eventType, listenerFunction, useCapture )
				return

class SWFServiceOperationProxy
	constructor: ( @id, @serviceId, @methodName, @args ) ->
		deferred = new Deferred()
		{ @promise, @resolve, @reject } = deferred

class SWFServiceEventListenerProxy
	constructor: ( @id, @serviceId, @eventType, @listenerFunction, @useCapture = false, @priority = 0, @useWeakReference = false ) ->
	
	redispatch: ( event ) ->
		return @listenerFunction( event )

class SWFServiceContext
	constructor: ( @id ) ->
		@serviceProxyRegistry = new DeferredEntityRegistry( SWFServiceProxy )
		@serviceOperationProxies = new EntitySet( SWFServiceOperationProxy )
		@serviceEventListenerProxies = new EntitySet( SWFServiceEventListenerProxy )
		return
	
	get: ( serviceId, timeout ) ->
		return @serviceProxyRegistry.get( serviceId, timeout )
	
	getServiceDescriptor: ( serviceId ) ->
		return @swf.SWFServiceContext_getServiceDescriptor( serviceId )
	
	getServiceProperty: ( serviceId, propertyName ) ->
		return @swf.SWFServiceContext_getServiceProperty( serviceId, propertyName )
	
	setServiceProperty: ( serviceId, propertyName, value ) ->
		@swf.SWFServiceContext_setServiceProperty( serviceId, propertyName, value )
		return 
	
	executeServiceMethod: ( serviceId, methodName, args ) ->
		returnValue = @swf.SWFServiceContext_executeServiceMethod( serviceId, methodName, args )
		if returnValue.pending
			serviceOperationProxy = new SWFServiceOperationProxy( returnValue.operationId, serviceId, methodName, args )
			@serviceOperationProxies.add( serviceOperationProxy )
			cleanUp = => @serviceOperationProxies.remove( serviceOperationProxy )
			serviceOperationProxy.promise.then( cleanUp, cleanUp )
			return serviceOperationProxy.promise
		return returnValue.value
	
	addServiceEventListener: ( serviceId, eventType, listenerFunction, useCapture, priority, weakReference ) ->
		serviceEventListenerProxyId = @swf.SWFServiceContext_addServiceEventListener( serviceId, eventType, useCapture, priority, weakReference )
		@serviceEventListenerProxies.add( new SWFServiceEventListenerProxy( serviceEventListenerProxyId, serviceId, eventType, listenerFunction, useCapture, priority, weakReference ) )
		return
	
	removeServiceEventListener: ( serviceId, eventType, listenerFunction, useCapture ) ->
		serviceEventListenerProxy = @serviceEventListenerProxies.find( { serviceId: serviceId, eventType: eventType, listenerFunction: listenerFunction, useCapture: useCapture } )[ 0 ]
		if serviceEventListenerProxy?
			@swf.SWFServiceContext_removeServiceEventListener( serviceId, serviceEventListenerProxy.id )
			@serviceEventListenerProxies.remove( serviceEventListenerProxy )
		return
	
	onServiceRegister: ( serviceId, serviceDescriptor ) ->
		@serviceProxyRegistry.register( new SWFServiceProxy( @, serviceId, serviceDescriptor ) )
		return
	
	onServiceExecuteComplete: ( serviceId, serviceOperationProxyId, action, value ) ->
		serviceOperationProxy = @serviceOperationProxies.get( serviceOperationProxyId )
		if serviceOperationProxy?
			serviceOperationProxy[ action ]( value )
		return
	
	onServiceEvent: ( serviceId, serviceEventListenerProxyId, event ) ->
		return @serviceEventListenerProxies.get( serviceEventListenerProxyId ).redispatch( event )

class SWFServiceContextManager
	constructor: ->
		@serviceContexts = new EntitySet( SWFServiceContext )
	
	add: ( serviceContext ) ->
		return @serviceContexts.add( serviceContext )
	
	getById: ( serviceContextId ) ->
		return @serviceContexts.get( serviceContextId )
	
	getBySWF: ( swf, timeout ) ->
		deferred = new Deferred()
		timer = new Timer( timeout )
		intervalId = setInterval( 
			=>
				try
					serviceContextId = swf.SWFServiceContext_getId()
				catch error
					# Intentionally ignored.
				if serviceContextId?
					clearInterval( intervalId )
					serviceContext = @serviceContexts.get( serviceContextId )
					serviceContext.swf ?= swf
					deferred.resolve( serviceContext )
				else
					if timer.expired()
						clearInterval( intervalId )
						deferred.reject( new Error(  'SWFService timed out attempting to access the requested SWF.' ) )
				return
			100
		)
		return deferred.promise

class SWFService
	constructor: ->
		@serviceContextManager = new SWFServiceContextManager()
	
	get: ( swf, serviceId, timeout = 30000 ) ->
		timer = new Timer( timeout )
		return @serviceContextManager
			.getBySWF( swf, timer.remaining() )
			.then( ( serviceContext ) -> 
				return serviceContext.get( serviceId, timer.remaining() )
			)
	
	onInit: ( serviceContextId ) ->
		@serviceContextManager.add( new SWFServiceContext( serviceContextId ) )
		return
	
	onServiceRegister: ( serviceContextId, serviceId, serviceDescriptor ) ->
		@serviceContextManager
			.getById( serviceContextId )
			.onServiceRegister( serviceId, serviceDescriptor )
		return
	
	onServiceExecuteComplete: ( serviceContextId, serviceId, operationId, action, value ) ->
		@serviceContextManager
			.getById( serviceContextId )
			.onServiceExecuteComplete( serviceId, operationId, action, value )
		return
	
	onServiceEvent: ( serviceContextId, serviceId, listenerId, event ) ->
		return @serviceContextManager
			.getById( serviceContextId )
			.onServiceEvent( serviceId, listenerId, event )

target = exports ? window
target.SWFService = new SWFService()
