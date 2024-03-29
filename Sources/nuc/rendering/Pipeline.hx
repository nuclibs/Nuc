package nuc.rendering;

import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexShader;
import kha.graphics4.FragmentShader;
import kha.FastFloat;

import nuc.math.Matrix3;
import nuc.math.Matrix4;
import nuc.utils.Float32Array;

import nuc.graphics.Texture;
import nuc.rendering.VertexBuffer;
import nuc.rendering.VertexStructure;
import nuc.rendering.Uniforms;

typedef BlendFactor = kha.graphics4.BlendingFactor;
typedef BlendOperation = kha.graphics4.BlendingOperation;
typedef CompareMode = kha.graphics4.CompareMode;
typedef CullMode = kha.graphics4.CullMode;

class Pipeline {

	public var uniforms(default, null):Uniforms;

	public var inputLayout(get, never):Array<VertexStructure>;
	inline function get_inputLayout() return _pipeline.inputLayout;

	public var vertexShader(get, never):VertexShader;
	inline function get_vertexShader() return _pipeline.vertexShader;

	public var fragmentShader(get, never):FragmentShader;
	inline function get_fragmentShader() return _pipeline.fragmentShader;

	public var cullMode(get, set):CullMode;
	inline function get_cullMode() return _pipeline.cullMode;
	inline function set_cullMode(v:CullMode) return _pipeline.cullMode = v;

	public var depthWrite(get, set):Bool;
	inline function get_depthWrite() return _pipeline.depthWrite;
	inline function set_depthWrite(v:Bool) return _pipeline.depthWrite = v;

	public var depthMode(get, set):CompareMode;
	inline function get_depthMode() return _pipeline.depthMode;
	inline function set_depthMode(v:CompareMode) return _pipeline.depthMode = v;

	public var colorWriteMask(never, set):Bool;
	inline function set_colorWriteMask(v:Bool) return _pipeline.colorWriteMask = v;

	public var colorWriteMaskRed(get, set):Bool;
	inline function get_colorWriteMaskRed() return _pipeline.colorWriteMaskRed;
	inline function set_colorWriteMaskRed(v:Bool) return _pipeline.colorWriteMaskRed = v;
	
	public var colorWriteMaskGreen(get, set):Bool;
	inline function get_colorWriteMaskGreen() return _pipeline.colorWriteMaskGreen;
	inline function set_colorWriteMaskGreen(v:Bool) return _pipeline.colorWriteMaskGreen = v;
	
	public var colorWriteMaskBlue(get, set):Bool;
	inline function get_colorWriteMaskBlue() return _pipeline.colorWriteMaskBlue;
	inline function set_colorWriteMaskBlue(v:Bool) return _pipeline.colorWriteMaskBlue = v;
	
	public var colorWriteMaskAlpha(get, set):Bool;
	inline function get_colorWriteMaskAlpha() return _pipeline.colorWriteMaskAlpha;
	inline function set_colorWriteMaskAlpha(v:Bool) return _pipeline.colorWriteMaskAlpha = v;
	
	public var conservativeRasterization(get, set):Bool;
	inline function get_conservativeRasterization() return _pipeline.conservativeRasterization;
	inline function set_conservativeRasterization(v:Bool) return _pipeline.conservativeRasterization = v;

	var _pipeline:PipelineState;
	var _textureParameters:TextureParameters;

	public function new(inputLayout:Array<VertexStructure>, vertexShader:VertexShader, fragmentShader:FragmentShader) {
		_pipeline = new PipelineState();
		_textureParameters = new TextureParameters();

		_pipeline.inputLayout = inputLayout;
		_pipeline.vertexShader = vertexShader;
		_pipeline.fragmentShader = fragmentShader;

		uniforms = new Uniforms(_pipeline);
	}

	public function use(g:Graphics) {
		g.setPipeline(_pipeline);
	}

	public function apply(g:Graphics) {
		uniforms.apply(g);
	}

	public function clone():Pipeline {
		var p = new Pipeline(inputLayout, vertexShader, fragmentShader);
		p.setBlending(
			_pipeline.blendSource,
			_pipeline.blendDestination,
			_pipeline.blendOperation,
			_pipeline.alphaBlendSource,
			_pipeline.alphaBlendDestination,
			_pipeline.alphaBlendOperation
		);
		return p;
	}

	public function setBlending(
		blendSrc:BlendFactor, blendDst:BlendFactor, ?blendOp:BlendOperation, 
		?alphaBlendSrc:BlendFactor, ?alphaBlendDst:BlendFactor, ?alphaBlendOp:BlendOperation
	) {
		_pipeline.blendSource = blendSrc;
		_pipeline.blendDestination = blendDst;
		_pipeline.blendOperation = blendOp != null ? blendOp : BlendOperation.Add;	

		_pipeline.alphaBlendSource = alphaBlendSrc != null ? alphaBlendSrc : blendSrc;
		_pipeline.alphaBlendDestination = alphaBlendDst != null ? alphaBlendDst : blendDst;
		_pipeline.alphaBlendOperation = alphaBlendOp != null ? alphaBlendOp : blendOp;	
	}

	public function setBool(name:String, value:Bool) return uniforms.setBool(name, value);
	public function setInt(name:String, value:Int) return uniforms.setInt(name, value);
	public function setFloat(name:String, value:FastFloat) return uniforms.setFloat(name, value);
	public function setFloat2(name:String, value:Array<FastFloat>) return uniforms.setFloat2(name, value);
	public function setFloat3(name:String, value:Array<FastFloat>) return uniforms.setFloat3(name, value);
	public function setFloat4(name:String, value:Array<FastFloat>) return uniforms.setFloat4(name, value);
	public function setFloats(name:String, value:Float32Array) return uniforms.setFloats(name, value);
	public function setMatrix3(name:String, value:Matrix3) return uniforms.setMatrix3(name, value);
	public function setMatrix4(name:String, value:Matrix4) return uniforms.setMatrix4(name, value);
	public function setTexture(name:String, value:Texture) return uniforms.setTexture(name, value);
	public function setTextureParameters(
		name:String, 
		uAddressing:TextureAddressing, vAddressing:TextureAddressing, 
		filterMin:TextureFilter, filterMag:TextureFilter, 
		mipmapFilter:MipMapFilter
	) {
		_textureParameters.uAddressing = uAddressing;
		_textureParameters.vAddressing = vAddressing;
		_textureParameters.filterMin = filterMin;
		_textureParameters.filterMag = filterMag;
		_textureParameters.mipmapFilter = mipmapFilter;
		return uniforms.setTextureParameters(name, _textureParameters);
	}

	public function compile() {
		_pipeline.compile();
	}

	public function dispose() {
		_pipeline.delete();
		uniforms = null;
		_pipeline = null;
	}

}
