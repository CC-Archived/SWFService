# [SWFService](http://github.com/CodeCatalyst/SWFService) v2.0
# Copyright (c) 2008-2013 [CodeCatalyst, LLC](http://www.codecatalyst.com/).
# Open source under the [MIT License](http://en.wikipedia.org/wiki/MIT_License).

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

class SWFServiceProxy
	constructor: ( serviceContext, @id ) ->
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
		
		serviceDescriptor = serviceContext.getServiceDescriptor( id )
		for accessor in serviceDescriptor.accessors
			Object.defineProperty( @, accessor.name, 
				writeable: accessor.access isnt 'readonly'
				get: createGetter( accessor.name )
				set: createSetter( accessor.name )
			)
		for variable in serviceDescriptor.variables
			Object.defineProperty( @, variable.name, 
				get: createGetter( variable.name )
				set: createSetter( variable.name )
			)
		for method in serviceDescriptor.methods
			@[ method.name ] = createMethod( method.name )
		
		if serviceDescriptor.isEventDispatcher
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
	
	matches: ( serviceId, eventType, listenerFunction, useCapture ) ->
		return @serviceId is serviceId and @eventType is eventType and @listenerFunction is listenerFunction and @useCapture is useCapture
	
	redispatch: ( event ) ->
		return @listenerFunction( event )

class SWFServiceContext
	constructor: ( @swf ) ->
		@id = @swf.SWFServiceContext_getId()
		@serviceProxies = new EntitySet( SWFServiceProxy )
		@serviceOperationProxies = new EntitySet( SWFServiceOperationProxy )
		@serviceEventListenerProxies = new EntitySet( SWFServiceEventListenerProxy )
		return
	
	get: ( serviceId ) ->
		return @serviceProxies.get( serviceId ) or @serviceProxies.add( new SWFServiceProxy( @, serviceId ) )
	
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
	
	onServiceExecuteComplete: ( serviceId, serviceOperationProxyId, action, value ) ->
		serviceOperationProxy = @serviceOperationProxies.get( serviceOperationProxyId )
		if serviceOperationProxy?
			serviceOperationProxy[ action ]( value )
			@serviceOperationProxies.remove( serviceOperationProxy )
		return
	
	onServiceEvent: ( serviceId, serviceEventListenerProxyId, event ) ->
		return @serviceEventListenerProxies.get( serviceEventListenerProxyId ).redispatch( event )

class SWFService
	constructor: ->
		@serviceContexts = new EntitySet( SWFServiceContext )
	
	get: ( swf, serviceId ) ->
		serviceContext = @serviceContexts.find( { swf: swf } )[ 0 ] or @serviceContexts.add( new SWFServiceContext( swf ) )
		return serviceContext.get( serviceId )
	
	onServiceExecuteComplete: ( serviceContextId, serviceId, operationId, action, value ) ->
		return @serviceContexts.get( serviceContextId ).onServiceExecuteComplete( serviceId, operationId, action, value )
	
	onServiceEvent: ( serviceContextId, serviceId, listenerId, event ) ->
		return @serviceContexts.get( serviceContextId ).onServiceEvent( serviceId, listenerId, event )

target = exports ? window
target.SWFService = new SWFService()
