describe( 'SWFService', ->
	
	booleanTestValues = [
		false
		true
	]
	intTestValues = [ 
		-2147483648
		0
		2147483647
	]
	uintTestValues = [ 
		0
		4294967295
	]
	numberTestValues = [ 
		1.79769313486231e+308
		0
		4.9406564584124654e-324
		Infinity
	]
	stringTestValues = [
		null
		''
		'0'
		'123'
		'3.14'
		'test'
		"'"
		'"'
		'Hello world!'
		'Γεια σας κόσμο!'
		'世界，你好！'
	]
	arrayTestValues = [
		null,
		[]
		[ 0 ]
		[ 1, 2, 3 ]
		[ true, 0, 4294967295, 3.14, 'test', [ 1, 2, 3 ], {} ]
	]
	objectTestValues = [
		null
		[]
		{}
		{ key: 'value' }
		{ booleanValue: true, intValue: 0, uintValue: 4294967295, numberValue: 3.14, stringValue: 'test', arrayValue: [ 1, 2, 3 ], objectValue: { key: 'value' } }
	]
	untypedTestValues = [
		null
		-2147483648
		2147483647
		0
		4294967295
		1.79769313486231e+308
		4.9406564584124654e-324
		Infinity
		''
		'0'
		'123'
		'3.14'
		'test'
		"'"
		'"'
		'Hello world!'
		'Γεια σας κόσμο!'
		'世界，你好！'
		[]
		[ 0 ]
		[ 1, 2, 3 ]
		[ true, 0, 4294967295, 3.14, 'test', [ 1, 2, 3 ], {} ]
		{}
		{ key: 'value' }
		{ booleanValue: true, intValue: 0, uintValue: 4294967295, numberValue: 3.14, stringValue: 'test', arrayValue: [ 1, 2, 3 ], objectValue: { key: 'value' } }
	]
	
	describe( 'Obtaining a JavaScript proxy', ->
		
		describe( 'get()', ->
			
			specify( 'returns a Promise of a reference to a JavaScript proxy for a registered service in the SWF', ->
				this.timeout( 30000 )
				
				promise = SWFService.get( 'TestSWF', 'TestService' )
				
				return promise.should.eventually.be.not.null
			)
			
			specify( 'throws an Error after the specified timeout if the specified SWF is not available', ->
				this.timeout( 500 )
				
				promise = SWFService.get( 'NonExistentSWF', 'NonExistentService', 250 )
				
				return promise.should.be.rejectedWith( Error, 'SWFService timed out attempting to access the requested SWF.' )
			)
			
			specify( 'throws an Error after the specified timeout if the specified service is not available for the specified SWF', ->
				this.timeout( 500 )
				
				promise = SWFService.get( 'TestSWF', 'NonExistentService', 250 )
				
				return promise.should.be.rejectedWith( Error, 'Request for SWF service proxy with id: "NonExistentService" timed out.' )
			)
			return
		)
		return
	)
	
	describe( 'JavaScript proxy operations', ->
		testService = null
		
		before( ( done ) ->
			SWFService
				.get( 'TestSWF', 'TestService' )
				.then( ( value ) ->
					testService = value
					done()
					return
				)
			return
		)
		
		describe( 'get and set properties', ->
			
			describe( 'Boolean', ->
				for value in booleanTestValues
					do ( value ) ->
						specify( value, ->
							testService.booleanProperty = value
							expect( testService.booleanProperty ).to.equal( value )
							return
						)
						return
				return
			)
			
			describe( 'int', ->
				for value in intTestValues
					do ( value ) ->
						specify( value, ->
							testService.intProperty = value
							expect( testService.intProperty ).to.equal( value )
							return
						)
						return
				return
			)
			
			describe( 'uint', ->
				for value in uintTestValues
					do ( value ) ->
						specify( value, ->
							testService.uintProperty = value
							expect( testService.uintProperty ).to.equal( value )
							return
						)
						return
				return
			)
			
			describe( 'Number', ->
				for value in numberTestValues
					do ( value ) ->
						specify( value, ->
							testService.numberProperty = value
							expect( testService.numberProperty ).to.equal( value )
							return
						)
						return
				return
			)
			
			describe( 'String', ->
				for value in stringTestValues
					do ( value ) ->
						specify( value, ->
							testService.stringProperty = value
							expect( testService.stringProperty ).to.equal( value )
							return
						)
						return
				return
			)
			
			describe( 'Array', ->
				for value in arrayTestValues
					do ( value ) ->
						specify( JSON.stringify( value ), ->
							testService.arrayProperty = value
							expect( testService.arrayProperty ).to.deep.equal( value )
							return
						)
						return
				return
			)
			
			describe( 'Object', ->
				for value in objectTestValues
					do ( value ) ->
						specify( JSON.stringify( value ), ->
							testService.objectProperty = value
							expect( testService.objectProperty ).to.deep.equal( value )
							return
						)
						return
				return
			)
			
			describe( 'untyped', ->
				for value in untypedTestValues
					do ( value ) ->
						specify( JSON.stringify( value ), ->
							testService.untypedProperty = value
							expect( testService.untypedProperty ).to.deep.equal( value )
							return
						)
						return
				return
			) 
			return
		)
		
		describe( 'get and set accessors', ->
			
			describe( 'Boolean', ->
				for value in booleanTestValues
					do ( value ) ->
						specify( value, ->
							testService.booleanAccessor = value
							expect( testService.booleanAccessor ).to.equal( value )
							return
						)
						return
				return
			)
			
			describe( 'int', ->
				for value in intTestValues
					do ( value ) ->
						specify( value, ->
							testService.intAccessor = value
							expect( testService.intAccessor ).to.equal( value )
							return
						)
						return
				return
			)
			
			describe( 'uint', ->
				for value in uintTestValues
					do ( value ) ->
						specify( value, ->
							testService.uintAccessor = value
							expect( testService.uintAccessor ).to.equal( value )
							return
						)
						return
				return
			)
			
			describe( 'Number', ->
				for value in numberTestValues
					do ( value ) ->
						specify( value, ->
							testService.numberAccessor = value
							expect( testService.numberAccessor ).to.equal( value )
							return
						)
						return
				return
			)
			
			describe( 'String', ->
				for value in stringTestValues
					do ( value ) ->
						specify( value, ->
							testService.stringAccessor = value
							expect( testService.stringAccessor ).to.equal( value )
							return
						)
						return
				return
			)
			
			describe( 'Array', ->
				for value in arrayTestValues
					do ( value ) ->
						specify( JSON.stringify( value ), ->
							testService.arrayAccessor = value
							expect( testService.arrayAccessor ).to.deep.equal( value )
							return
						)
						return
				return
			)
			
			describe( 'Object', ->
				for value in objectTestValues
					do ( value ) ->
						specify( JSON.stringify( value ), ->
							testService.objectAccessor = value
							expect( testService.objectAccessor ).to.deep.equal( value )
							return
						)
						return
				return
			)
			
			describe( 'untyped', ->
				for value in untypedTestValues
					do ( value ) ->
						specify( JSON.stringify( value ), ->
							testService.untypedAccessor = value
							expect( testService.untypedAccessor ).to.deep.equal( value )
							return
						)
						return
				return
			) 
			return
		)
		
		describe( 'call synchronous and asynchronous methods', ->
			
			describe( 'call a synchronous method', ->
				
				describe( 'passing parameters', ->
					
					describe( 'Boolean', ->
						for value in booleanTestValues
							do ( value ) ->
								specify( value, ->
									testService.setBoolean( value )
									expect( testService.booleanProperty ).to.equal( value )
									return
								)
								return
						return
					)
					
					describe( 'int', ->
						for value in intTestValues
							do ( value ) ->
								specify( value, ->
									testService.setInt( value )
									expect( testService.intProperty ).to.equal( value )
									return
								)
								return
						return
					)
					
					describe( 'uint', ->
						for value in uintTestValues
							do ( value ) ->
								specify( value, ->
									testService.setUint( value )
									expect( testService.uintProperty ).to.equal( value )
									return
								)
								return
						return
					)
					
					describe( 'Number', ->
						for value in numberTestValues
							do ( value ) ->
								specify( value, ->
									testService.setNumber( value )
									expect( testService.numberProperty ).to.equal( value )
									return
								)
								return
						return
					)
					
					describe( 'String', ->
						for value in stringTestValues
							do ( value ) ->
								specify( value, ->
									testService.setString( value )
									expect( testService.stringProperty ).to.equal( value )
									return
								)
								return
						return
					)
					
					describe( 'Array', ->
						for value in arrayTestValues
							do ( value ) ->
								specify( JSON.stringify( value ), ->
									testService.setArray( value )
									expect( testService.arrayProperty ).to.deep.equal( value )
									return
								)
								return
						return
					)
					
					describe( 'Object', ->
						for value in objectTestValues
							do ( value ) ->
								specify( JSON.stringify( value ), ->
									testService.setObject( value )
									expect( testService.objectProperty ).to.deep.equal( value )
									return
								)
								return
						return
					)
					
					describe( 'untyped', ->
						for value in untypedTestValues
							do ( value ) ->
								specify( JSON.stringify( value ), ->
									testService.setUntyped( value )
									expect( testService.untypedProperty ).to.deep.equal( value )
									return
								)
								return
						return
					)
					
					describe( 'variadic (i.e. with a variable number of parameters)', ->
						for count in [0..untypedTestValues.length]
							parameters = untypedTestValues.slice( 0, count )
							do ( parameters ) ->
								specify( parameters.length, ->
									expect( testService.getVariadicParametersCount.apply( testService, parameters ) ).to.equal( parameters.length )
									return
								)
						return
					)
					return
				)
				
				describe( 'returning values', ->
					
					describe( 'Boolean', ->
						for value in booleanTestValues
							do ( value ) ->
								specify( value, ->
									testService.setBoolean( value )
									expect( testService.getBoolean() ).to.equal( value )
									return
								)
								return
						return
					)
					
					describe( 'int', ->
						for value in intTestValues
							do ( value ) ->
								specify( value, ->
									testService.setInt( value )
									expect( testService.getInt() ).to.equal( value )
									return
								)
								return
						return
					)
					
					describe( 'uint', ->
						for value in uintTestValues
							do ( value ) ->
								specify( value, ->
									testService.setUint( value )
									expect( testService.getUint() ).to.equal( value )
									return
								)
								return
						return
					)
					
					describe( 'Number', ->
						for value in numberTestValues
							do ( value ) ->
								specify( value, ->
									testService.setNumber( value )
									expect( testService.getNumber() ).to.equal( value )
									return
								)
								return
						return
					)
					
					describe( 'String', ->
						for value in stringTestValues
							do ( value ) ->
								specify( value, ->
									testService.setString( value )
									expect( testService.getString() ).to.equal( value )
									return
								)
								return
						return
					)
					
					describe( 'Array', ->
						for value in arrayTestValues
							do ( value ) ->
								specify( JSON.stringify( value ), ->
									testService.setArray( value )
									expect( testService.getArray() ).to.deep.equal( value )
									return
								)
								return
						return
					)
					
					describe( 'Object', ->
						for value in objectTestValues
							do ( value ) ->
								specify( JSON.stringify( value ), ->
									testService.setObject( value )
									expect( testService.getObject() ).to.deep.equal( value )
									return
								)
								return
						return
					)
					
					describe( 'untyped', ->
						for value in untypedTestValues
							do ( value ) ->
								specify( JSON.stringify( value ), ->
									testService.setUntyped( value )
									expect( testService.getUntyped() ).to.deep.equal( value )
									return
								)
								return
						return
					)
					return
				)
				return
			)
			
			describe( 'call an asynchronous method', ->
				
				describe( 'returning an AsyncToken', ->
					
					describe( 'that succeeds with a result', ->
						for value in untypedTestValues
							do ( value ) ->
								specify( JSON.stringify( value ), ->
									return expect( testService.returnSuccessfulAsyncToken( value ) ).to.eventually.deep.equal( value )
								)
								return
						return
					)
					
					describe( 'that fails with a fault', ->
						fault =
							faultCode: 'Expected fault code'
							faultString: 'Expected fault string'
							faultDetail: 'Expected fault detail'
						specify( JSON.stringify( fault ), ->
							return expect( testService.returnFailingAsyncToken( fault.faultCode, fault.faultString, fault.faultDetail ) ).to.be.rejectedWith( fault )
						)
						return
					)
					return
				)
				
				describe( 'returning a Promise', ->
					
					describe( 'that will later fulfill with a result', ->
						for value in untypedTestValues
							do ( value ) ->
								specify( JSON.stringify( value ), ->
									return expect( testService.returnFulfillingPromise( value ) ).to.eventually.deep.equal( value )
								)
								return
						return
					)
					
					describe( 'that will later reject with a reason', ->
						reason = 'expected reason'
						specify( reason, ->
							return expect( testService.returnRejectingPromise( reason ) ).to.be.rejectedWith( reason )
						)
						return
					)
					
					describe( 'fulfilled with a result', ->
						for value in untypedTestValues
							do ( value ) ->
								specify( JSON.stringify( value ), ->
									return expect( testService.returnFulfilledPromise( value ) ).to.eventually.deep.equal( value )
								)
								return
						return
					)
					
					describe( 'rejected with a reason', ->
						reason = 'expected reason'
						specify( reason, ->
							return expect( testService.returnRejectedPromise( reason ) ).to.be.rejectedWith( reason )
						)
						return
					)
					return
				)
			)
			return
		)
		
		describe( 'add and remove event listeners', ->
			beforeEach( ->
				testService.booleanProperty = true
				testService.intProperty = 0
				testService.uintProperty = 4294967295
				testService.numberProperty = 3.14
				testService.stringProperty = 'test'
				testService.arrayProperty = [ 1, 2, 3 ]
				testService.objectProperty = { booleanValue: true, intValue: 0, uintValue: 4294967295, numberValue: 3.14, stringValue: 'test', arrayValue: [ 1, 2, 3 ], objectValue: { key: 'value' } }
				testService.untypedProperty = { booleanValue: true, intValue: 0, uintValue: 4294967295, numberValue: 3.14, stringValue: 'test', arrayValue: [ 1, 2, 3 ], objectValue: { key: 'value' } }
				return
			)
			
			specify( 'Custom Event', ->
				expectedEventPayload =
					type: 'event'
					booleanProperty: testService.booleanProperty
					intProperty: testService.intProperty
					uintProperty: testService.uintProperty
					numberProperty: testService.numberProperty
					stringProperty: testService.stringProperty
					arrayProperty: testService.arrayProperty
					objectProperty: testService.objectProperty
					untypedProperty: testService.untypedProperty
					booleanAccessor: testService.booleanProperty
					intAccessor: testService.intProperty
					uintAccessor: testService.uintProperty
					numberAccessor: testService.numberProperty
					stringAccessor: testService.stringProperty
					arrayAccessor: testService.arrayProperty
					objectAccessor: testService.objectProperty
					untypedAccessor: testService.untypedProperty
				
				eventListener = sinon.spy()
				testService.addEventListener( 'event', eventListener )
				testService.triggerEvent()
				expect( eventListener ).to.be.calledWithMatch( expectedEventPayload )
				eventListener.reset()
				testService.removeEventListener( 'event', eventListener )
				testService.triggerEvent()
				expect( eventListener ).not.to.have.been.called
				return
			)
			
			specify( 'Custom DynamicEvent', ->
				expectedDynamicEventPayload =
					type: 'dynamicEvent'
					booleanProperty: testService.booleanProperty
					intProperty: testService.intProperty
					uintProperty: testService.uintProperty
					numberProperty: testService.numberProperty
					stringProperty: testService.stringProperty
					arrayProperty: testService.arrayProperty
					objectProperty: testService.objectProperty
					untypedProperty: testService.untypedProperty
				
				eventListener = sinon.spy()
				testService.addEventListener( 'dynamicEvent', eventListener )
				testService.triggerDynamicEvent()
				expect( eventListener ).to.be.calledWithMatch( expectedDynamicEventPayload )
				eventListener.reset()
				testService.removeEventListener( 'dynamicEvent', eventListener )
				testService.triggerDynamicEvent()
				expect( eventListener ).not.to.have.been.called
				return
			)
			return
		)
		return
	)
	
)