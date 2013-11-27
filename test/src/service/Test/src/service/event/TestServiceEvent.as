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

package service.event
{
	import flash.events.Event;

	public class TestServiceEvent extends Event
	{
		// ========================================
		// Public static constants
		// ========================================
		
		/**
		 * Event type.
		 */
		public static const EVENT:String = "event";
		
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
		
		/**
		 * Boolean property accessor.
		 */
		public function get booleanAccessor():Boolean
		{
			return booleanProperty;
		}

		/**
		 * int property accessor.
		 */
		public function get intAccessor():int
		{
			return intProperty;
		}

		/**
		 * uint property accessor.
		 */
		public function get uintAccessor():uint
		{
			return uintProperty;
		}

		/**
		 * Number property accessor.
		 */
		public function get numberAccessor():Number
		{
			return numberProperty;
		}

		/**
		 * String property accessor.
		 */
		public function get stringAccessor():String
		{
			return stringProperty;
		}

		/**
		 * Array property accessor.
		 */
		public function get arrayAccessor():Array
		{
			return arrayProperty;
		}

		/**
		 * Object property accessor.
		 */
		public function get objectAccessor():Object
		{
			return objectProperty;
		}

		/**
		 * Untyped property accessor.
		 */
		public function get untypedAccessor():*
		{
			return untypedProperty;
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		public function TestServiceEvent( type:String, booleanValue:Boolean, intValue:int, uintValue:uint, numberValue:Number, stringValue:String, arrayValue:Array, objectValue:Object, untypedValue:* )
		{
			super( type );
			
			this.booleanProperty  = booleanValue;
			this.intProperty      = intValue;
			this.uintProperty     = uintValue;
			this.numberProperty   = numberValue;
			this.stringProperty   = stringValue;
			this.arrayProperty    = arrayValue;
			this.objectProperty   = objectValue;
			this.untypedProperty  = untypedValue;
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		override public function clone():Event 
		{
			return new TestServiceEvent( type, booleanProperty, intProperty, uintProperty, numberProperty, stringProperty, arrayProperty, objectProperty, untypedProperty );
		}
	}
}