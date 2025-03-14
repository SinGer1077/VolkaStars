package;

import kha.graphics5_.PipelineState;
import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

import kha.Color;
import kha.Shaders;
import kha.graphics4.Graphics2;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexData;
import kha.graphics4.IndexBuffer;
import kha.graphics4.Usage;
import kha.graphics4.VertexShader;
import kha.graphics4.FragmentShader;
import Math;

class Star{

    static var vBuffer: VertexBuffer;
    static var iBuffer: IndexBuffer;
    static var vertexData: kha.arrays.Float32Array;
    static var pipeline: PipelineState;
    static var structure: VertexStructure;

    static var vertices:Array<Float>;
    static var indices:Array<Int>;

    public function new() {
        structure = new VertexStructure();
        structure.add("pos", VertexData.Float32_2X);           
        fillBuffers(32, structure);
    }

    function fillBuffers(segments:Int, structure: VertexStructure) {
        var angleStep = (2 * Math.PI) / segments;
        
        var vertexCount = segments + 1; 
        var indicesCount = segments * 3;  

        vBuffer = new VertexBuffer(vertexCount, structure, Usage.StaticUsage);
        vertexData = vBuffer.lock();

        iBuffer = new IndexBuffer(indicesCount, Usage.StaticUsage);
        var indexData = iBuffer.lock();

        vertexData[0] = 0; 
        vertexData[1] = 0; 

        for (i in 0...segments) {
            var angle = i * angleStep;
            
            var x = Math.cos(angle);
            var y = Math.sin(angle);

            var index = (i + 1) * 2;
            vertexData[index] = x;
            vertexData[index + 1] = y;

            indexData[i * 3] = 0;
            indexData[i * 3 + 1] = i + 1;
            indexData[i * 3 + 2] = if (i + 2 > segments) 1 else i + 2;
        }

        vBuffer.unlock();
        iBuffer.unlock();

        pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
        pipeline.vertexShader = Shaders.simple_vert;
		pipeline.fragmentShader = Shaders.simple_frag;	
		pipeline.colorAttachmentCount = 1;
		pipeline.colorAttachments[0] = kha.graphics4.TextureFormat.RGBA32;
		pipeline.depthStencilAttachment = kha.graphics4.DepthStencilFormat.Depth16;
		pipeline.compile();

        trace("Vertex Count:", vBuffer.count());
        trace("Index Count:", iBuffer.count());
    }

    public function render(frames: Array<Framebuffer>): Void {
		final fb = frames[0];
        final g4 = fb.g4;

        g4.begin();       
        g4.clear(Color.Green, Math.POSITIVE_INFINITY);   

		g4.setPipeline(pipeline);

        g4.setVertexBuffer(vBuffer);
		g4.setIndexBuffer(iBuffer);

        g4.drawIndexedVertices();

        g4.end();
	}   

    private function start(): Void{
        
    }
}