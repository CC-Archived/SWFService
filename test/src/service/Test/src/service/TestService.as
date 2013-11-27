////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2008-2013 CodeCatalyst, LLC - http://www.codecatalyst.com/
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.	
////////////////////////////////////////////////////////////////////////////////

package service
{
	import com.codecatalyst.promise.Deferred;
	import com.codecatalyst.promise.Promise;
	import com.codecatalyst.util.nextTick;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.mx_internal;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import service.event.TestServiceDynamicEvent;
	import service.event.TestServiceEvent;

	use namespace mx_internal;
	
	
	[Event(name="dynamicEvent", type="service.event.TestServiceDynamicEvent")]
	[Event(name="event", type="service.event.TestServiceEvent")]
	/**
	 * Test Service for SWFService
	 * 
	 * Provides accessors, properties and methods and dispatches events for JavaScript driven unit tests.
	 */
	public class TestService extends EventDispatcher
	{
		// ========================================
		// Public properties
		// ========================================

		/**
		 * Boolean property.
		 */
		public var booleanProperty:Boolean;
		
		/**
		 * int property.
		 */
		public var intProperty:int;
		
		/**
		 * uint property.
		 */
		public var uintProperty:uint;
		
		/**
		 * Number property.
		 */
		public var numberProperty:Number;
		
		/**
		 * String property.
		 */
		public var stringProperty:String;
		
		/**
		 * Array property.
		 */
		public var arrayProperty:Array;
		
		/**
		 * Object property.
		 */
		public var objectProperty:Object;
		
		/**
		 * Untyped property.
		 */
		public var untypedProperty:*;
		
		[Bindable( "booleanAccessorChanged" )]
		/**
		 * Boolean property accessor.
		 */
		public function get booleanAccessor():Boolean
		{
			return booleanProperty;
		}
		
		public function set booleanAccessor( value:Boolean ):void
		{
			if ( booleanProperty != value ) {
				booleanProperty = value;
				dispatchEvent( new Event( "booleanAccessorChanged" ) );
			}
		}
		
		[Bindable( "intAccessorChanged" )]
		/**
		 * int property accessor.
		 */
		public function get intAccessor():int
		{
			return intProperty;
		}
		
		public function set intAccessor( value:int ):void
		{
			if ( intProperty != value ) {
				intProperty = value;
				dispatchEvent( new Event( "intAccessorChanged" ) );
			}
		}
		
		[Bindable( "uintAccessorChanged" )]
		/**
		 * uint property accessor.
		 */
		public function get uintAccessor():uint
		{
			return uintProperty;
		}
		
		public function set uintAccessor( value:uint ):void
		{
			if ( uintProperty != value ) {
				uintProperty = value;
				dispatchEvent( new Event( "uintAccessorChanged" ) );
			}
		}
		
		[Bindable( "numberAccessorChanged" )]
		/**
		 * Number property accessor.
		 */
		public function get numberAccessor():Number
		{
			return numberProperty;
		}
		
		public function set numberAccessor( value:Number ):void
		{
			if ( numberProperty != value ) {
				numberProperty = value;
				dispatchEvent( new Event( "numberAccessorChanged" ) );
			}
		}
		
		[Bindable( "stringAccessorChanged" )]
		/**
		 * String property accessor.
		 */
		public function get stringAccessor():String
		{
			return stringProperty;
		}
		
		public function set stringAccessor( value:String ):void
		{
			if ( stringProperty != value ) {
				stringProperty = value;
				dispatchEvent( new Event( "stringAccessorChanged" ) );
			}
		}
		
		[Bindable( "arrayAccessorChanged" )]
		/**
		 * Array property accessor.
		 */
		public function get arrayAccessor():Array
		{
			return arrayProperty;
		}
		
		public function set arrayAccessor( value:Array ):void
		{
			if ( arrayProperty != value ) {
				arrayProperty = value;
				dispatchEvent( new Event( "arrayAccessorChanged" ) );
			}
		}
		
		[Bindable( "objectAccessorChanged" )]
		/**
		 * Object property accessor.
		 */
		public function get objectAccessor():Object
		{
			return objectProperty;
		}
		
		public function set objectAccessor( value:Object ):void
		{
			if ( objectProperty != value ) {
				objectProperty = value;
				dispatchEvent( new Event( "objectAccessorChanged" ) );
			}
		}
		
		[Bindable( "untypedAccessorChanged" )]
		/**
		 * Untyped property accessor.
		 */
		public function get untypedAccessor():*
		{
			return untypedProperty;
		}
		
		public function set untypedAccessor( value:* ):void
		{
			if ( untypedProperty != value ) {
				untypedProperty = value;
				dispatchEvent( new Event( "untypedAccessorChanged" ) );
			}
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		public function TestService()
		{
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Sets the Boolean property to the specified Boolean value.
		 * 
		 * @param value Boolean value
		 */
		public function setBoolean( value:Boolean ):void
		{
			this.booleanProperty = value;
		}
		
		/**
		 * Sets the int property to the specified int value.
		 * 
		 * @param value int value
		 * @throws Error "Expected a int value." if an invalid parameter is specified.
		 */
		public function setInt( value:int ):void
		{
			this.intProperty = value;
		}
		
		/**
		 * Sets the uint property to the specified uint value.
		 * 
		 * @param value uint value
		 */
		public function setUint( value:uint ):void
		{
			this.uintProperty = value;
		}

		/**
		 * Sets the Number property to the specified Number value.
		 * 
		 * @param value Number value
		 */
		public function setNumber( value:Number ):void
		{
			this.numberProperty = value;
		}

		/**
		 * Sets the String property to the specified String value.
		 * 
		 * @param value String value
		 */
		public function setString( value:String ):void
		{
			this.stringProperty = value;
		}

		/**
		 * Sets the Array property to the specified Array value.
		 * 
		 * @param value Array value
		 */
		public function setArray( value:Array ):void
		{
			this.arrayProperty = value;
		}
		
		/**
		 * Sets the Object property to the specified Object value.
		 * 
		 * @param value Object value
		 */
		public function setObject( value:Object ):void
		{
			this.objectProperty = value;
		}
		
		/**
		 * Sets the untyped property to the specified untyped value.
		 * 
		 * @param value Untyped value
		 */
		public function setUntyped( value:* ):void
		{
			this.untypedProperty = value;
		}
		
		/**
		 * Returns the value of the Boolean property.
		 * 
		 * @return The current value of the Boolean property.
		 */
		public function getBoolean():Boolean
		{
			return booleanProperty;
		}

		/**
		 * Returns the value of the int property.
		 * 
		 * @return The current value of the int property.
		 */
		public function getInt():int
		{
			return intProperty;
		}
		
		/**
		 * Returns the value of the uint property.
		 * 
		 * @return The current value of the uint property.
		 */
		public function getUint():uint
		{
			return uintProperty;
		}

		/**
		 * Returns the value of the Number property.
		 * 
		 * @return The current value of the Number property.
		 */
		public function getNumber():Number
		{
			return numberProperty;
		}

		/**
		 * Returns the value of the String property.
		 * 
		 * @return The current value of the String property.
		 */
		public function getString():String
		{
			return stringProperty;
		}
		
		/**
		 * Returns the value of the Array property.
		 * 
		 * @return The current value of the Array property.
		 */
		public function getArray():Array
		{
			return arrayProperty;
		}
		
		/**
		 * Returns the value of the Array property.
		 * 
		 * @return The current value of the Array property.
		 */
		public function getObject():Object
		{
			return objectProperty;
		}
		
		/**
		 * Returns the value of the untyped property.
		 * 
		 * @return The current value of the untyped property.
		 */
		public function getUntyped():*
		{
			return untypedProperty;
		}
		
		/**
		 * Returns a count of variable number of parameters specified.
		 * 
		 * @return The number of parameters received.
		 */
		public function getVariadicParametersCount(... parameters):int
		{
			return parameters.length;
		}

		/**
		 * Returns an AsyncToken that will later succeed with the specified result.
		 * 
		 * @param result Result value.
		 * @return An AsyncToken that will later succeed with the specified result.
		 */
		public function returnSuccessfulAsyncToken( result:* ):AsyncToken
		{
			var token:AsyncToken = new AsyncToken();
			
			nextTick( function ():void {
				token.applyResult( new ResultEvent( ResultEvent.RESULT, false, true, result, token ) );
			} );
			
			return token;
		}

		/**
		 * Returns an AsyncToken that will later fail with the specified fault code, string and detail.
		 * 
		 * @param faultCode Fault code.
		 * @param faultString Fault string.
		 * @param faultDetail Fault detail.
		 * @return An AsyncToken that will later fail with the specified fault code, string and detail.
		 */
		public function returnFailingAsyncToken( faultCode:String, faultString:String, faultDetail:String ):AsyncToken
		{
			var token:AsyncToken = new AsyncToken();

			nextTick( function ():void {
				token.applyFault( new FaultEvent( FaultEvent.FAULT, false, true, new Fault( faultCode, faultString, faultDetail ), token ) );
			} );
			
			return token;
		}

		/**
		 * Returns a Promise that will later fulfill with the specified value.
		 * 
		 * @param value Fulfillment value.
		 * @return A Promise that will later fulfill with the specified value.
		 */
		public function returnFulfillingPromise( value:* ):Promise
		{
			var deferred:Deferred = new Deferred();
			
			nextTick( function ():void {
				deferred.resolve( value );
			} );
			
			return deferred.promise;
		}
		
		/**
		 * Returns a Promise that will later reject with the specified reason.
		 * 
		 * @param value Rejection reason.
		 * @return A Promise that will later reject with the specified reason.
		 */
		public function returnRejectingPromise( reason:* ):Promise
		{
			var deferred:Deferred = new Deferred();
			
			nextTick( function ():void {
				deferred.reject( reason );
			} );
			
			return deferred.promise;
		}
		
		/**
		 * Returns a Promise fulfilled with the specified value.
		 * 
		 * @param value Fulfillment value.
		 * @return A Promise fulfilled with the specified value.
		 */
		public function returnFulfilledPromise( value:* ):Promise
		{
			return Deferred.resolve( value );
		}
		
		/**
		 * Returns a Promise rejected with the specified reason.
		 * 
		 * @param value Rejection reason value.
		 * @return A Promise rejected with the specified reason.
		 */
		public function returnRejectedPromise( reason:* ):Promise
		{
			return Deferred.reject( reason );
		}
		
		/**
		 * Triggers a test event with the current Boolean, int, uint, Number, String, Array, Object and untyped property values.
		 */
		public function triggerEvent():void
		{
			dispatchEvent( new TestServiceEvent( TestServiceEvent.EVENT, booleanProperty, intProperty, uintProperty, numberProperty, stringProperty, arrayProperty, objectProperty, untypedProperty ) );
		}
		
		/**
		 * Triggers a dynamic test event populated with the current Boolean, int, uint, Number, String, Array, Object and untyped property values.
		 */
		public function triggerDynamicEvent():void
		{
			var event:TestServiceDynamicEvent = new TestServiceDynamicEvent( TestServiceDynamicEvent.DYNAMIC_EVENT );
			
			event.booleanProperty = booleanProperty;
			event.intProperty = intProperty;
			event.uintProperty = uintProperty;
			event.numberProperty = numberProperty;
			event.stringProperty = stringProperty;
			event.arrayProperty = arrayProperty;
			event.objectProperty = objectProperty;
			event.untypedProperty = untypedProperty;
			
			dispatchEvent( event );
		}
	}
}