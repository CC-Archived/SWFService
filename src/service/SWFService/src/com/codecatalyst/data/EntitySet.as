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

package com.codecatalyst.data
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * Manages a set of uniquely identified Entities.
	 */
	public class EntitySet
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Entity class.
		 */
		protected var entityClass:Class = null;

		/**
		 * Entity key property.
		 */
		protected var entityKeyProperty:String = null;
		
		/**
		 * Entities, indexed by key.
		 */
		protected var entitiesByKey:Dictionary = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		public function EntitySet( entityClass:Class, entityKeyProperty:String = "id" )
		{
			super();
			
			this.entityClass = entityClass;
			this.entityKeyProperty = entityKeyProperty;
			
			this.entitiesByKey = new Dictionary();
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Add an entity to this entity set.
		 */
		public function add( entity:Object ):Object
		{
			if ( ! ( entity is entityClass ) )
				throw new Error( "Entity must be of type: " + getQualifiedClassName( entityClass ) + " to be added to this EntitySet." );

			var entityKey:* = entity[ entityKeyProperty ];
			if ( exists( entityKey ) )
				throw new Error( "An Entity with the key: " + entityKey + " already exists in this EntitySet." );
			entitiesByKey[ entityKey ] = entity;
			
			return entity;
		}
		
		/**
		 * Remove an entity from this entity set.
		 */
		public function remove( entity:Object ):Object
		{
			if ( contains( entity ) )
			{
				delete entitiesByKey[ entity[ entityKeyProperty ] ];
				return entity;
			}
			
			return null;
		}
		
		/**
		 * Remove all entities from this entity set.
		 */
		public function removeAll():void
		{
			this.entitiesByKey = new Dictionary();
		}
		
		/**
		 * Get an entity from this entity set by its key.
		 */
		public function get( key:* ):Object
		{
			return entitiesByKey[ key ];
		}
		
		/**
		 * Find entities in this entity set by that match the specified attributes.
		 */
		public function find( attributes:Object ):Array
		{
			function matches( entity:Object ):Boolean
			{
				for ( var attribute:String in attributes )
				{
					if ( entity[ attribute ] !=  attributes[ attribute ] )
						return false;
				}
				
				return true;
			}
			
			return match( matches );
		}
		
		/**
		 * Find entities in this entity set that pass the specified matcher function.
		 */
		public function match( matcherFunction:Function ):Array
		{
			var matchingEntities:Array = new Array();
			for each ( var entity:Object in entitiesByKey )
			{
				if ( matcherFunction( entity ) )
					matchingEntities.push( entity );
			}
			
			return matchingEntities;
		}
		
		/**
		 * Check if this entity set contains the specified entity.
		 */
		public function contains( entity:Object ):Boolean
		{
			var entityKey:* = entity[ entityKeyProperty ];
			
			return exists( entityKey ) && entity == get( entityKey );
		}
		
		/**
		 * Check if this entity set contains an entity with the specified key.
		 */
		public function exists( key:* ):Boolean
		{
			return entitiesByKey[ key ] != null;
		}
		
		/**
		 * Returns an Array of the entities in this entity set.
		 */
		public function toArray():Array
		{
			var entities:Array = new Array();
			for each ( var entity:Object in entitiesByKey )
			{
				entities.push( entity );
			}
			
			return entities;
		}
	}
}