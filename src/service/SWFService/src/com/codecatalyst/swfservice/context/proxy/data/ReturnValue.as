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
	/**
	 * @private
	 */
	public class ReturnValue
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>operationId</code>.
		 */
		protected var _operationId:String = null;
		
		/**
		 * Backing variable for <code>pending</code>.
		 */
		protected var _pending:Boolean = false;
		
		/**
		 * Backing variable for <code>value</code>.
		 */
		protected var _value:* = null;
		
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Service operation unique identifier.
		 */
		public function get operationId():String
		{
			return _operationId;
		}
		
		/**
		 * Indicates whether the return value for the associated service 
		 * operation is pending.
		 */
		public function get pending():Boolean
		{
			return _pending;
		}
		
		/**
		 * Service operation return value, if available (i.e. not pending).
		 */
		public function get value():*
		{
			return _value;
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		public function ReturnValue( operationId:String, pending:Boolean, value:* = null )
		{
			super();
			
			this._operationId = operationId;
			this._pending = pending;
			this._value = value;
		}
	}
}