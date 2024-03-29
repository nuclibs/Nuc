package nuc.audio;

import haxe.io.Bytes;
import nuc.utils.Float32Array;
import nuc.resources.Resource;
import nuc.Resources;

class Sound extends Resource {

	public var sound:kha.Sound;

	public var duration(get, never):Float;
	inline function get_duration() return sound.length;

	public var channels(get, never):Int;
	inline function get_channels() return sound.channels;

	public var compressedData(get, set):Bytes;
	inline function get_compressedData() return sound.compressedData;
	inline function set_compressedData(v:Bytes) return sound.compressedData = v;
	
	public var uncompressedData(get, set):Float32Array;
	inline function get_uncompressedData() return sound.uncompressedData;
	inline function set_uncompressedData(v:Float32Array) return sound.uncompressedData = v;

	public var sampleRate(get, never):Int;
	inline function get_sampleRate() return sound.sampleRate;

	@:allow(nuc.Resources)
	function new(?sound:kha.Sound) {
		if(sound == null) sound = new kha.Sound();
		this.sound = sound;
		resourceType = ResourceType.SOUND;
	}

	public inline function uncompress(done:()->Void) {
		sound.uncompress(done);
	}

	override function unload() {
		sound.unload();
		sound = null;
	}

	override function memoryUse() {
        return sound.uncompressedData.length;
	}

}
