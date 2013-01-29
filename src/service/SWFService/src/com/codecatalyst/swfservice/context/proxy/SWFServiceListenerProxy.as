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
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import mx.utils.UIDUtil;
	
	/**
	 * @private
	 */
	public class SWFServiceListenerProxy
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
		 * Backing variable for <code>type</code>.
		 */
		protected var _type:String = null;
		
		/**
		 * Backing variable for <code>useCapture</code>.
		 */
		protected var _useCapture:Boolean = false;
		
		/**
		 * Backing variable for <code>priority</code>.
		 */
		protected var _priority:int = 0;
		
		/**
		 * Backing variable for <code>useWeakReference</code>.
		 */
		protected var _useWeakReference:Boolean = false;
		
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
		 * Event type.
		 */
		public function get type():String
		{
			return _type;
		}
		
		/**
		 * Indicates whether this listener is registered for the capture phase or the target and bubbling phases.
		 */
		public function get useCapture():Boolean
		{
			return _useCapture;
		}
		
		/**
		 * Priority level.
		 */
		public function get priority():int
		{
			return _priority;
		}
		
		/**
		 * Indicates whether this listener is registered as a weak or strong reference.
		 */
		public function get useWeakReference():Boolean
		{
			return _useWeakReference;
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		public function SWFServiceListenerProxy( serviceProxy:SWFServiceProxy, type:String, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false )
		{
			super();
			
			this._id = UIDUtil.createUID();
			
			this._serviceProxy = serviceProxy;
			this._type = type;
			this._useCapture = useCapture;
			this._priority = priority;
			this._useWeakReference = useWeakReference;	
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Attach this listener to the service instance.
		 */
		public function attach():void
		{
			serviceProxy.serviceInstance.addEventListener( type, redispatch, useCapture, priority, useWeakReference );
		}
		
		/**
		 * Detach this listener from the service instance.
		 */
		public function detach():void
		{
			serviceProxy.serviceInstance.removeEventListener( type, redispatch, useCapture );
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Redispatch the specified event to be handled by a JavaScript listener.
		 */
		protected function redispatch( event:Event ):Boolean
		{
			return ExternalInterface.call( "SWFService.onServiceEvent", serviceProxy.serviceContext.id, serviceProxy.id, id, event );
		}
	}
}