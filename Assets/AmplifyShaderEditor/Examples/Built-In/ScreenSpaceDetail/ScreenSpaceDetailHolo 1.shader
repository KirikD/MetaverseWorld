// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASESampleShaders/ScreenSpaceDetailHolo"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Scal("Scal", Vector) = (8,6,0,0)
		_Checkers("Checkers", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Albedo("Albedo", 2D) = "white" {}
		_DisplScal("DisplScal", Float) = 0.1
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		_Emis("Emis", Color) = (0,0,0,0)
		_MinScale("MinScale", Float) = 0.23
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _Checkers;
		uniform float2 _Scal;
		uniform float _MinScale;
		uniform sampler2D _TextureSample0;
		uniform float _DisplScal;
		uniform float4 _Emis;
		uniform float _DissolveAmount;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float2 uv_Albedo = v.texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 temp_output_6_0 = (ase_screenPosNorm).xy;
			float4 temp_output_8_0 = ( tex2Dlod( _Albedo, float4( uv_Albedo, 0, 0.0) ) * tex2Dlod( _Checkers, float4( ( temp_output_6_0 * _Scal * ( _SinTime.x + _MinScale ) ), 0, 0.0) ) * tex2Dlod( _TextureSample0, float4( ( temp_output_6_0 * _Scal * ( _CosTime.x + _MinScale ) ), 0, 0.0) ) );
			v.vertex.xyz += ( float4( ase_vertexNormal , 0.0 ) * temp_output_8_0 * _DisplScal ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 temp_output_6_0 = (ase_screenPosNorm).xy;
			float4 temp_output_8_0 = ( tex2D( _Albedo, uv_Albedo ) * tex2D( _Checkers, ( temp_output_6_0 * _Scal * ( _SinTime.x + _MinScale ) ) ) * tex2D( _TextureSample0, ( temp_output_6_0 * _Scal * ( _CosTime.x + _MinScale ) ) ) );
			o.Albedo = temp_output_8_0.rgb;
			o.Emission = _Emis.rgb;
			o.Alpha = 1;
			clip( ( (-0.6 + (( 1.0 - _DissolveAmount ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + temp_output_8_0 ).r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
118;1088;1514;609;4331.853;281.6951;3.588456;True;True
Node;AmplifyShaderEditor.RangedFloatNode;35;-1539.187,633.1727;Inherit;False;Property;_MinScale;MinScale;8;0;Create;True;0;0;0;False;0;False;0.23;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosTime;12;-1628.973,800.5172;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;11;-1488.141,331.9486;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;4;-2171.971,134.2722;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;6;-1915.971,134.2722;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1282.487,733.1984;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1067.644,372.1133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;10;-1698.483,475.5133;Float;False;Property;_Scal;Scal;1;0;Create;True;0;0;0;False;0;False;8,6;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;29;-30.79242,570.3818;Float;False;Property;_DissolveAmount;Dissolve Amount;6;0;Create;True;0;0;0;False;0;False;0;0.28;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1078.89,622.8914;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-948.8,160;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-537.3115,-80;Inherit;True;Property;_Albedo;Albedo;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;30;233.0029,571.2277;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-613.8901,591.8914;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;4d901885c71a57041a96c5e30b1ac116;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-670.8,152;Inherit;True;Property;_Checkers;Checkers;2;0;Create;True;0;0;0;False;0;False;-1;None;4d901885c71a57041a96c5e30b1ac116;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-199,88;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;31;361.8195,572.0123;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-125.6428,419.3746;Inherit;False;Property;_DisplScal;DisplScal;5;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;25;-150.855,251.2538;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;38;-1525.968,-39.8501;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;33;324.6146,121.4087;Inherit;False;Property;_Emis;Emis;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0,0.6841278,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;40;-1772.452,3.101379;Inherit;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;37;-1785.697,-153.0933;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;142.1611,346.2144;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;427.5653,412.9142;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;39;-2035.772,-225.8132;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;36;-2344.388,-143.5769;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;599.5287,8.832493;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ASESampleShaders/ScreenSpaceDetailHolo;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;4;0
WireConnection;34;0;12;1
WireConnection;34;1;35;0
WireConnection;13;0;11;1
WireConnection;13;1;35;0
WireConnection;18;0;6;0
WireConnection;18;1;10;0
WireConnection;18;2;34;0
WireConnection;9;0;6;0
WireConnection;9;1;10;0
WireConnection;9;2;13;0
WireConnection;30;0;29;0
WireConnection;21;1;18;0
WireConnection;2;1;9;0
WireConnection;8;0;1;0
WireConnection;8;1;2;0
WireConnection;8;2;21;0
WireConnection;31;0;30;0
WireConnection;38;0;37;0
WireConnection;38;1;40;0
WireConnection;40;0;36;0
WireConnection;37;0;39;0
WireConnection;26;0;25;0
WireConnection;26;1;8;0
WireConnection;26;2;28;0
WireConnection;32;0;31;0
WireConnection;32;1;8;0
WireConnection;39;0;36;0
WireConnection;0;0;8;0
WireConnection;0;2;33;0
WireConnection;0;10;32;0
WireConnection;0;11;26;0
ASEEND*/
//CHKSM=9AD2DC2E049A2FD7DA47A0D5D075F49B4B8D9AC0