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

package com.codecatalyst.swfservice.context
{
	import com.codecatalyst.data.EntitySet;
	import com.codecatalyst.swfservice.context.proxy.SWFServiceProxy;
	import com.codecatalyst.swfservice.context.proxy.data.Descriptor;
	import com.codecatalyst.swfservice.context.proxy.data.ReturnValue;
	
	import flash.external.ExternalInterface;
	
	import mx.utils.UIDUtil;

	/**
	 * @private
	 */
	public class SWFServiceContext
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>id</code>.
		 */
		protected var _id:String = null;
		
		/**
		 * Registered service proxies.
		 */
		protected var serviceProxies:EntitySet;
		
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
		
		// ========================================
		// Constructor
		// ========================================
		
		public function SWFServiceContext()
		{
			super();
			
			this._id = UIDUtil.createUID();
			
			this.serviceProxies = new EntitySet( SWFServiceProxy );
			
			ExternalInterface.addCallback( "SWFServiceContext_getId", getId );
			
			ExternalInterface.addCallback( "SWFServiceContext_getServiceProperty", getServiceProperty );
			ExternalInterface.addCallback( "SWFServiceContext_setServiceProperty", setServiceProperty );
			ExternalInterface.addCallback( "SWFServiceContext_executeServiceMethod", executeServiceMethod );
			ExternalInterface.addCallback( "SWFServiceContext_addServiceEventListener", addServiceEventListener );
			ExternalInterface.addCallback( "SWFServiceContext_removeServiceEventListener", removeServiceEventListener );
			
			ExternalInterface.call( "SWFService.onInit", id );
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Register the specified service instance to make it available for JavaScript interaction via the specified service identifier.
		 */
		public function registerService( serviceId:String, serviceInstance:Object ):SWFServiceProxy
		{
			var serviceProxy:SWFServiceProxy = new SWFServiceProxy( this, serviceId, serviceInstance );
			serviceProxies.add( serviceProxy );
			
			ExternalInterface.call( "SWFService.onServiceRegister", id, serviceProxy.id, serviceProxy.descriptor );
			
			return serviceProxy;
		}
		
		/**
		 * Unregister the specified service instance.
		 */
		public function unregisterService( serviceId:String ):void
		{
			serviceProxies.remove( serviceId );
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Get the corresponding service proxy for the specified service identifier.
		 */
		protected function getServiceProxy( serviceId:String ):SWFServiceProxy
		{
			return serviceProxies.get( serviceId ) as SWFServiceProxy;
		}
		
		/**
		 * Handle a JavaScript request to get the service context id.
		 */
		protected function getId():String
		{
			return id;
		}
		
		/**
		 * Handle a JavaScript request to get a service property.
		 */
		protected function getServiceProperty( serviceId:String, propertyName:String ):*
		{
			return getServiceProxy( serviceId ).getPropertyValue( propertyName );
		}
		
		/**
		 * Handle a JavaScript request to set a service property.
		 */
		protected function setServiceProperty( serviceId:String, propertyName:String, value:* ):void
		{
			getServiceProxy( serviceId ).setPropertyValue( propertyName, value );
		}
		
		/**
		 * Handle a JavaScript request to execute a service method.
		 */
		protected function executeServiceMethod( serviceId:String, methodName:String, parameters:Array = null ):ReturnValue
		{
			return getServiceProxy( serviceId ).execute( methodName, parameters );
		}
		
		/**
		 * Handle a JavaScript request to add an event listener to a service.
		 */
		protected function addServiceEventListener( serviceId:String, type:String, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):String
		{
			return getServiceProxy( serviceId ).addEventListener( type, useCapture, priority, useWeakReference );
		}
		
		/**
		 * Handle a JavaScript request to remove an event listener from a service.
		 */
		protected function removeServiceEventListener( serviceId:String, serviceEventListenerProxyId:String ):void
		{
			return getServiceProxy( serviceId ).removeEventListener( serviceEventListenerProxyId );
		}
	}
}