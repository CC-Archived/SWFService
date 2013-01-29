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

package com.codecatalyst.swfservice.context.proxy
{
	import com.codecatalyst.promise.Promise;
	
	import flash.external.ExternalInterface;
	
	import mx.rpc.AsyncToken;
	import mx.utils.UIDUtil;

	/**
	 * @private
	 */
	public class SWFServiceOperationProxy
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>id</code>.
		 */
		protected var _id:String = null;
		
		/**
		 * Backing variable for <code>serviceProxy</code>.
		 */
		protected var _serviceProxy:SWFServiceProxy = null;
		
		/**
		 * Backing variable for <code>method</code>.
		 */
		protected var _methodName:String = null;
		
		/**
		 * Backing variable for <code>parameters</code>.
		 */
		protected var _parameters:Array = null;
		
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Unique identifier.
		 */
		public function get id():String
		{
			return _id;
		}
		
		/**
		 * Service proxy.
		 */
		public function get serviceProxy():SWFServiceProxy
		{
			return _serviceProxy;
		}
		
		/**
		 * Method name.
		 */
		public function get methodName():String
		{
			return _methodName;
		}
		
		/**
		 * Parameters.
		 */
		public function get parameters():Array
		{
			return _parameters;
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		public function SWFServiceOperationProxy( serviceProxy:SWFServiceProxy, methodName:String, parameters:Array = null )
		{
			super();
			
			this._id = UIDUtil.createUID();
			
			this._serviceProxy = serviceProxy;
			this._methodName = methodName;
			this._parameters = parameters;
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Execute the specified service instance method with the specified parameters.
		 */
		public function execute():*
		{
			var returnValue:* = serviceProxy.serviceInstance[ methodName ].apply( null, parameters );
			
			if ( returnValue is AsyncToken || returnValue is Promise )
				return Promise.when( returnValue ).then( resolve, reject );
			
			return returnValue;
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Resolve this aysnchronous operation.
		 */
		protected function resolve( value:* ):*
		{
			complete( "resolve", value );
			
			return value;
		}
		
		/**
		 * Reject this aysnchronous operation.
		 */
		protected function reject( error:* ):*
		{
			complete( "reject", error );
			
			return error;
		}
		
		/**
		 * Complete this asynchronous operation.
		 */
		protected function complete( action:String, value:* ):void
		{
			ExternalInterface.call( "SWFService.onServiceExecuteComplete", serviceProxy.serviceContext.id, serviceProxy.id, id, action, value );
		}
	}
}