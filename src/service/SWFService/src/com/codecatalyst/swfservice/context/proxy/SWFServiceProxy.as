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
	import com.codecatalyst.data.EntitySet;
	import com.codecatalyst.promise.Promise;
	import com.codecatalyst.swfservice.context.SWFServiceContext;
	import com.codecatalyst.swfservice.context.proxy.data.Descriptor;
	import com.codecatalyst.swfservice.context.proxy.data.ReturnValue;

	/**
	 * @private
	 */
	public class SWFServiceProxy
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>id</code>.
		 */
		protected var _id:String = null;
		
		/**
		 * Backing variable for <code>serviceContext</code>.
		 */
		protected var _serviceContext:SWFServiceContext;
		
		/**
		 * Backing variable for <code>serviceInstance</code>.
		 */
		protected var _serviceInstance:Object = null;
		
		/**
		 * Backing variable for <code>descriptor</code>.
		 */
		protected var _descriptor:Descriptor = null;
		
		/**
		 * Pending service operations proxies.
		 */
		protected var serviceOperationProxies:EntitySet = null;
		
		/**
		 * Active service event listener proxies.
		 */
		protected var serviceEventListenerProxies:EntitySet = null;
		
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
		 * Service context.
		 */
		public function get serviceContext():SWFServiceContext
		{
			return _serviceContext;
		}
		
		/**
		 * Service instance.
		 */
		public function get serviceInstance():Object
		{
			return _serviceInstance;
		}
		
		/**
		 * Service proxy descriptor.
		 */
		public function get descriptor():Descriptor
		{
			return _descriptor;
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		public function SWFServiceProxy( serviceContext:SWFServiceContext, id:String, serviceInstance:Object )
		{
			super();
			
			this._serviceContext = serviceContext;
			this._id = id;
			this._serviceInstance = serviceInstance;
			this._descriptor = new Descriptor( this );
			
			this.serviceOperationProxies = new EntitySet( SWFServiceOperationProxy );
			this.serviceEventListenerProxies = new EntitySet( SWFServiceListenerProxy );
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Get a Service property value by name.
		 */
		public function getPropertyValue( propertyName:String ):*
		{
			return serviceInstance[ propertyName ];
		}
		
		/**
		 * Set a Service property value by name, with the specified value.
		 */
		public function setPropertyValue( propertyName:String, value:* ):void
		{
			serviceInstance[ propertyName ] = value;
		}
		
		/**
		 * Execute a Service method by name, with the specified parameters.
		 */
		public function execute( methodName:String, parameters:Array = null ):ReturnValue
		{
			var serviceOperationProxy:SWFServiceOperationProxy = new SWFServiceOperationProxy( this, methodName, parameters );
			
			var returnValue:* = serviceOperationProxy.execute();
			if ( returnValue is Promise )
			{
				serviceOperationProxies.add( serviceOperationProxy );
				
				function removeServiceOperation( value:* ):void
				{
					serviceOperationProxies.remove( serviceOperationProxy );
				}
				
				returnValue.then( removeServiceOperation, removeServiceOperation );
				
				return new ReturnValue( serviceOperationProxy.id, true );
			}
			else
			{
				return new ReturnValue( serviceOperationProxy.id, false, returnValue ); 
			}
		}
		
		/**
		 * Add a JavaScript listener for a Service event.
		 */
		public function addEventListener( type:String, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):String
		{
			var serviceEventListenerProxy:SWFServiceListenerProxy = new SWFServiceListenerProxy( this, type, useCapture, priority, useWeakReference );
			serviceEventListenerProxies.add( serviceEventListenerProxy );
			
			serviceEventListenerProxy.attach();
			
			return serviceEventListenerProxy.id;
		}
		
		/**
		 * Remove a JavaScript listener for a Service event.
		 */
		public function removeEventListener( serviceEventListenerProxyId:String ):void
		{
			var serviceEventListenerProxy:SWFServiceListenerProxy = serviceEventListenerProxies.get( serviceEventListenerProxyId ) as SWFServiceListenerProxy;
			if ( serviceEventListenerProxy != null )
			{
				serviceEventListenerProxy.detach();
				
				serviceEventListenerProxies.remove( serviceEventListenerProxy );
			}
		}		
	}
}