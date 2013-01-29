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

package com.codecatalyst.swfservice
{
	import com.codecatalyst.swfservice.context.SWFServiceContext;

	/**
	 * Allows ActionScript developers to register an ActionScript class instance
	 * as a JavaScript service.
	 * 
	 * Once an ActionScript class instance is registered with SWFService, 
	 * JavaScript developers can obtain a dynamically generated proxy object to 
	 * transparently interact with it; including getting and setting properties 
	 * and accessors, calling synchronous and asynchronous methods, and adding 
	 * and removing event listeners.
	 */
	public class SWFService
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Service context.
		 */
		protected static const context:SWFServiceContext = new SWFServiceContext();
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Register the specified service instance to make it available for JavaScript interaction via the specified service identifier.
		 */
		public static function register( serviceId:String, serviceInstance:Object ):void
		{
			context.registerService( serviceId, serviceInstance );
		}
		
		/**
		 * Unregister the specified service instance.
		 */
		public static function unregister( serviceId:String ):void
		{
			context.unregisterService( serviceId );
		}
	}
}