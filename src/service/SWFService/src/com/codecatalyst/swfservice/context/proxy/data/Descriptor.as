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

package com.codecatalyst.swfservice.context.proxy.data
{
	import com.codecatalyst.swfservice.context.proxy.SWFServiceProxy;
	
	import flash.events.EventDispatcher;
	
	import mx.utils.DescribeTypeCache;
	
	/**
	 * @private
	 */
	public class Descriptor
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>id</code>.
		 */
		protected var _id:String = null;
		
		/**
		 * Backing variable for <code>variables</code>.
		 */
		protected var _variables:Array = null;
		
		/**
		 * Backing variable for <code>accessors</code>.
		 */
		protected var _accessors:Array = null;
		
		/**
		 * Backing variable for <code>methods</code>.
		 */
		protected var _methods:Array = null;
		
		/**
		 * Backing variable for <code>isEventDispatcher</code>.
		 */
		protected var _isEventDispatcher:Boolean = false;
		
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Unique identifier for the associated service instance.
		 */
		public function get id():String
		{
			return _id;
		}
		
		/**
		 * Variables for the associated service instance.
		 */
		public function get variables():Array
		{
			return _variables;
		}
		
		/**
		 * Accessors for the associated service instance.
		 */
		public function get accessors():Array
		{
			return _accessors;
		}
		
		/**
		 * Methods for the associated service instance.
		 */
		public function get methods():Array
		{
			return _methods;
		}
		
		/**
		 * Indicates whether the associated service instance is an EventDispatcher.
		 */
		public function get isEventDispatcher():Boolean
		{
			return _isEventDispatcher;
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		public function Descriptor( serviceProxy:SWFServiceProxy )
		{
			super();
			
			var description:XML = DescribeTypeCache.describeType( serviceProxy.serviceInstance ).typeDescription;
			
			this._id = serviceProxy.id;
			
			this._variables = [];
			for each ( var variable:XML in description.variable )
			{
				this._variables.push( new Variable( variable.@name.toString(), variable.@type.toString() ) );
			}
			
			this._accessors = [];
			for each ( var accessor:XML in description.accessor )
			{
				this._accessors.push( new Accessor( accessor.@name.toString(), accessor.@type.toString(), accessor.@access.toString() ) );
			}
			
			this._methods = [];
			for each ( var method:XML in description.method )
			{
				if ( method.@declaredBy != "flash.events::EventDispatcher" )
				{
					var parameters:Array = [];
					for each ( var parameter:XML in method.parameter )
					{
						var parameterIndex:int = parameter.@index - 1;
						parameters[ parameterIndex ] = new MethodParameter( parameter.@type.toString(), parameter.@optional.toString() == "true" );
					}
					
					this._methods.push( new Method( method.@name.toString(), parameters, method.@returnType.toString() ) );
				}
			}
			
			this._isEventDispatcher = serviceProxy.serviceInstance is EventDispatcher;
		}
	}
}