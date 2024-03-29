package nuc.graphics;

import haxe.io.Bytes;
import nuc.resources.Resource;
import nuc.Resources;
import nuc.utils.Log;

typedef TextureFormat = kha.graphics4.TextureFormat;
typedef DepthStencilFormat = kha.graphics4.DepthStencilFormat;

typedef TextureFilter = kha.graphics4.TextureFilter;
typedef MipMapFilter = kha.graphics4.MipMapFilter;
typedef TextureAddressing = kha.graphics4.TextureAddressing;

class Texture extends Resource {

	static public var maxSize(get, never):Int;
	static inline function get_maxSize() return kha.Image.maxSize;
	
	static public var renderTargetsInvertedY(get, never):Bool;
	static inline function get_renderTargetsInvertedY() return kha.Image.renderTargetsInvertedY();

	static public var nonPow2Supported(get, never):Bool;
	static inline function get_nonPow2Supported() return kha.Image.nonPow2Supported;

	static public function create(width:Int, height:Int, ?format:TextureFormat) {
		var img = kha.Image.create(width, height, format);
		return new Texture(img);
	}

	static public function createFromBytes(bytes:Bytes, width:Int, height:Int, ?format:TextureFormat) {
		var img = kha.Image.fromBytes(bytes, width, height, format);
		return new Texture(img);
	}

	static public function createRenderTarget(width:Int, height:Int, ?format:TextureFormat, ?depthStencil:DepthStencilFormat, ?antialiasing:Int) {
		var img = kha.Image.createRenderTarget(width, height, format, depthStencil, antialiasing);
		var t = new Texture(img, true);
		t.resourceType = ResourceType.RENDERTEXTURE;
		return t;
	}

	public var widthActual(get, never):Int;
	inline function get_widthActual() return image.realWidth;
	
	public var heightActual(get, never):Int;
	inline function get_heightActual() return image.realHeight;

	public var width(get, never):Int;
	inline function get_width() return image.width;
	
	public var height(get, never):Int;
	inline function get_height() return image.height;

	public var format(get, never):TextureFormat;
	inline function get_format() return image.format;

	public var isRenderTarget(default, null):Bool;

	public var image:kha.Image;

	@:allow(nuc.Resources)
	function new(image:kha.Image, renderTarget:Bool = false) {
		this.image = image;
		isRenderTarget = renderTarget;
		
		resourceType = ResourceType.TEXTURE;
	}

	public inline function generateMipmaps(levels:Int) {
		image.generateMipmaps(levels);
	}

	public inline function lock(level:Int = 0):Bytes {
		return image.lock(level);
	}

	public inline function unlock() {
		image.unlock();
	}

	public inline function get_bytes():Bytes {
		return image.getPixels();
	}

	override function unload() {
		image.unload();
		image = null;
	}

	override function memoryUse() {
		// return (widthActual * heightActual * image.depth);
		return (image.stride * heightActual * image.depth);
	}

}
