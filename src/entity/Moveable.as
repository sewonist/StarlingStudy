package entity
{
	import starling.animation.IAnimatable;
	import starling.display.DisplayObjectContainer;
	
	public class Moveable extends DisplayObjectContainer implements IAnimatable
	{
		/**
		 * Entity -type- to consider solid when colliding.
		 */
		public var solid:String = "solid";
		
		public var hasCollision:Boolean = false;
		
		/**
		 * Movement constants.
		 */
		public var MAXX:Number = 250;
		public var MAXY:Number = 1400;
		public var GRAV:Number = 2000;
		public var FLOAT:Number = 3000;
		public var ACCEL:Number = 1600;
		public var DRAG:Number = 800;
		public var JUMP:Number = -1200;
		public var LEAP:Number = 1.5;
		
		/**
		 * Movement properties.
		 */
		public var onSolid:Boolean;
		public var spdX:Number = 0;
		public var spdY:Number = 0;
		
		/**
		 * Helper vars used by move().
		 */
		private var _moveX:Number = 0;
		private var _moveY:Number = 0;
		
		public function Moveable()
		{
		}
		
		public function advanceTime(time:Number):void
		{
			checkFloor();
			gravity(time);
			move(spdX * time, spdY * time);
		}
		
		/**
		 * Moves the entity by the specified amount horizontally and vertically.
		 */
		public function move(moveX:Number = 0, moveY:Number = 0):void
		{
			// movement counters
			_moveX += moveX;
			_moveY += moveY;
			moveX = Math.round(_moveX);
			moveY = Math.round(_moveY);
			_moveX -= moveX;
			_moveY -= moveY;
			
			// movement vars
			var sign:int;
			
			// horizontal
			if (moveX != 0)
			{
				sign = moveX > 0 ? 1 : -1;
				while (moveX != 0)
				{
					moveX -= sign;
					x += sign;
				}
			}
			
			// vertical
			if (moveY != 0)
			{
				sign = moveY > 0 ? 1 : -1;
				while (moveY != 0)
				{
					moveY -= sign;
					if (collideFloor(x, y + sign))
					{
						moveY = 0;
						onSolid = true;
					}
					else y += sign;
				}
			}
		}
		
		
		
		public function collideFloor(x:Number, y:Number):Boolean
		{
			if( y > 180 ) return true;
			else return false;
		}
		
		/**
		 * Check floor
		 */
		protected function checkFloor():Boolean
		{
			if(y>180) onSolid = true;
			else onSolid = false;
			
			return onSolid;
		}
		
		/**
		 * Applies gravity to the player.
		 */
		protected function gravity(time:Number):void
		{
			if (onSolid) return;
			var g:Number = GRAV;
			if (spdY < 0) g += FLOAT;
			spdY += g * time;
			if (spdY > MAXY) spdY = MAXY;
		}
	}

}