package nuc.resources;

import nuc.Resources;

@:allow(nuc.Resources)
class Resource {

	public var name:String;
	public var id(default, null):Int = -1;
    public var resourceType(default, null):ResourceType;
    public var references(default, null):Int = 0;
    public var loaded(default, null):Bool = false;

	public function unload() {}

	public function memoryUse():Int {
		return 0;
	}

	public function ref() {
		references++;
	}

	public function unref() {
		references--;
	}

}