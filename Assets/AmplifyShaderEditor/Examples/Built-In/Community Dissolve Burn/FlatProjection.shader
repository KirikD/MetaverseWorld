// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASESampleShaders/Community/TOPFlatProjection 1"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Normal("Normal", 2D) = "bump" {}
		_DisolveGuide1("Disolve Guide1", 2D) = "white" {}
		_DisolveGuide2("Disolve Guide2", 2D) = "white" {}
		_DissolveAmount("Dissolve Amount", Range( 0 , 2)) = 0
		_Displace("Displace", Range( -0.5 , 0.5)) = 0
		_SizeLines("SizeLines", Float) = 999
		_ColorMain("ColorMain", Color) = (0.2520217,1,0.1273585,0)
		_AnimDivB("AnimDivB", Range( -1 , 1)) = 0.15
		_AnimDivC("AnimDivC", Range( -1 , 1)) = 0.15
		_ColorEmiss("ColorEmiss", Color) = (0,0.3679245,0.2178739,0)
		_MeshDrag("MeshDrag", Vector) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _DissolveAmount;
		uniform sampler2D _DisolveGuide1;
		uniform float _SizeLines;
		uniform float _AnimDivB;
		uniform sampler2D _DisolveGuide2;
		uniform float _AnimDivC;
		uniform float _Displace;
		uniform float3 _MeshDrag;
		uniform sampler2D _Normal;
		uniform float4 _ColorMain;
		uniform float4 _ColorEmiss;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float4 ase_vertex4Pos = v.vertex;
			float4 unityObjectToClipPos172 = UnityObjectToClipPos( ase_vertex4Pos.xyz );
			float4 computeScreenPos171 = ComputeScreenPos( unityObjectToClipPos172 );
			float temp_output_173_0 = (ase_vertex4Pos).w;
			float4 temp_output_184_0 = ( ( computeScreenPos171 * temp_output_173_0 ) * _SizeLines );
			float4 temp_output_182_0 = ( temp_output_184_0 + 99.0 + ( _SinTime.x * _AnimDivB ) );
			float temp_output_73_0 = ( (-0.6 + (( 1.0 - _DissolveAmount ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2Dlod( _DisolveGuide1, float4( temp_output_182_0.xy, 0, 1.0) ).r + tex2Dlod( _DisolveGuide2, float4( ( temp_output_184_0 + 99.0 + ( ( _CosTime.x * _AnimDivC ) * _SizeLines ) ).xy, 0, 1.0) ).r );
			v.vertex.xyz += ( ( ase_worldNormal * temp_output_73_0 * _Displace ) + _MeshDrag );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 unityObjectToClipPos172 = UnityObjectToClipPos( ase_vertex4Pos.xyz );
			float4 computeScreenPos171 = ComputeScreenPos( unityObjectToClipPos172 );
			float temp_output_173_0 = (ase_vertex4Pos).w;
			float4 temp_output_184_0 = ( ( computeScreenPos171 * temp_output_173_0 ) * _SizeLines );
			float4 temp_output_182_0 = ( temp_output_184_0 + 99.0 + ( _SinTime.x * _AnimDivB ) );
			o.Normal = UnpackNormal( tex2D( _Normal, temp_output_182_0.xy ) );
			o.Albedo = _ColorMain.rgb;
			o.Emission = _ColorEmiss.rgb;
			o.Alpha = 1;
			float temp_output_73_0 = ( (-0.6 + (( 1.0 - _DissolveAmount ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2D( _DisolveGuide1, temp_output_182_0.xy ).r + tex2D( _DisolveGuide2, ( temp_output_184_0 + 99.0 + ( ( _CosTime.x * _AnimDivC ) * _SizeLines ) ).xy ).r );
			clip( temp_output_73_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
408;24;1514;597;1981.006;-349.9243;1.154591;True;True
Node;AmplifyShaderEditor.PosVertexDataNode;170;-2046.056,664.9464;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;172;-1738.927,618.3867;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;193;-1447.652,1370.318;Inherit;False;Property;_AnimDivC;AnimDivC;14;0;Create;True;0;0;0;False;0;False;0.15;-0.1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;173;-1449.658,820.3851;Inherit;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;171;-1487.365,655.43;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CosTime;192;-1448.042,1208.727;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;177;-1460.639,936.4493;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;128;-967.3727,510.0833;Inherit;False;908.2314;498.3652;Dissolve - Opacity Mask;7;4;71;2;73;111;182;181;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;-1215.511,520.8036;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;188;-1560.229,1118.253;Inherit;False;Property;_AnimDivB;AnimDivB;13;0;Create;True;0;0;0;False;0;False;0.15;0.1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-1197.249,903.9229;Inherit;False;Property;_SizeLines;SizeLines;11;0;Create;True;0;0;0;False;0;False;999;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-1229.868,1229.69;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-1072.249,756.8229;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;195;-849.105,1017.605;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-919.0424,582.2975;Float;False;Property;_DissolveAmount;Dissolve Amount;7;0;Create;True;0;0;0;False;0;False;0;1.057;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;181;-854.682,940.54;Inherit;False;Constant;_Float3;Float 3;10;0;Create;True;0;0;0;False;0;False;99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;-1275.445,1004.625;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-1017.249,1137.823;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;182;-878.4641,807.9075;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;71;-655.2471,583.1434;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;196;-803.0273,1104.198;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCRemapNode;111;-521.4305,581.9279;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;156;-603.3788,1053.312;Inherit;True;Property;_DisolveGuide2;Disolve Guide2;5;0;Create;True;0;0;0;False;0;False;-1;0bbd24355cfb3074392f4e25176bc9da;9cc702118bd6cab469286d448e956b0d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-660.3626,761.1237;Inherit;True;Property;_DisolveGuide1;Disolve Guide1;4;0;Create;True;0;0;0;False;0;False;-1;0bbd24355cfb3074392f4e25176bc9da;9cc702118bd6cab469286d448e956b0d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;160;-57.08832,1141.994;Float;False;Property;_Displace;Displace;8;0;Create;True;0;0;0;False;0;False;0;0.01;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-319.6845,566.4299;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;159;-25.11678,734.1024;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;199;389.421,791.0723;Inherit;False;Property;_MeshDrag;MeshDrag;16;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;132;144.1929,26.72195;Inherit;False;765.1592;493.9802;Created by The Four Headed Cat @fourheadedcat - www.twitter.com/fourheadedcat;2;0;191;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;129;-892.9326,49.09825;Inherit;False;814.5701;432.0292;Burn Effect - Emission;6;113;126;115;114;112;130;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;324.0332,649.606;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;112;-878.1525,280.8961;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-4;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;131;-313.0316,-299.3296;Inherit;True;Property;_Normal;Normal;3;0;Create;True;0;0;0;False;0;False;-1;None;02d2e693b08407a45a2e72f9cb0d7e20;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;114;-422.1431,295.0128;Inherit;True;Property;_BurnRamp;Burn Ramp;6;0;Create;True;0;0;0;False;0;False;-1;None;64e7766099ad46747a07014e44d0aea1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;135;-990.4471,-203.321;Inherit;True;Property;_EmissA;EmissA;2;0;Create;True;0;0;0;False;0;False;-1;None;94cd628d3d8e07d40a85d82b3fdad15d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;115;-610.9893,313.0966;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;191;170.7953,322.2712;Inherit;False;Property;_ColorEmiss;ColorEmiss;15;0;Create;True;0;0;0;False;0;False;0,0.3679245,0.2178739,0;0,0.3679245,0.2178739,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;78;-195.8022,-593.1658;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;0;False;0;False;-1;None;0bbd24355cfb3074392f4e25176bc9da;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-202.3633,125.7657;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;141;-1451.691,-398.313;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;113;-797.634,90.31517;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;162;428.7297,-194.9904;Inherit;False;Property;_ColorMain;ColorMain;12;0;Create;True;0;0;0;False;0;False;0.2520217,1,0.1273585,0;0.1254902,0.2355516,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;158;-48.62109,1023.586;Inherit;False;Constant;_Float1;Float 1;8;0;Create;True;0;0;0;False;0;False;0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-1621.041,-314.3391;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;167;-1616.909,436.2882;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;155;-1255.779,-427.0171;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;197;526.421,610.0723;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;138;271.3606,-451.3076;Inherit;False;Property;_MullCol;MullCol;10;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;144;-1927.041,-261.3391;Inherit;False;Property;_AnimDivA;AnimDivA;9;0;Create;True;0;0;0;False;0;False;0.04;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;174;-1203.39,773.2914;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;140;-1824.915,-336.7525;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;130;-627.5982,83.10277;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;137;10.79348,84.1115;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;538.637,87.61272;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ASESampleShaders/Community/TOPFlatProjection 1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;172;0;170;0
WireConnection;173;0;170;0
WireConnection;171;0;172;0
WireConnection;200;0;171;0
WireConnection;200;1;173;0
WireConnection;194;0;192;1
WireConnection;194;1;193;0
WireConnection;184;0;200;0
WireConnection;184;1;186;0
WireConnection;187;0;177;1
WireConnection;187;1;188;0
WireConnection;185;0;194;0
WireConnection;185;1;186;0
WireConnection;182;0;184;0
WireConnection;182;1;181;0
WireConnection;182;2;187;0
WireConnection;71;0;4;0
WireConnection;196;0;184;0
WireConnection;196;1;195;0
WireConnection;196;2;185;0
WireConnection;111;0;71;0
WireConnection;156;1;196;0
WireConnection;2;1;182;0
WireConnection;73;0;111;0
WireConnection;73;1;2;1
WireConnection;73;2;156;1
WireConnection;157;0;159;0
WireConnection;157;1;73;0
WireConnection;157;2;160;0
WireConnection;112;0;73;0
WireConnection;131;1;182;0
WireConnection;114;1;115;0
WireConnection;135;1;155;0
WireConnection;115;0;130;0
WireConnection;78;1;155;0
WireConnection;126;0;130;0
WireConnection;126;1;114;0
WireConnection;141;0;146;0
WireConnection;141;1;146;0
WireConnection;113;0;112;0
WireConnection;146;0;140;0
WireConnection;146;1;144;0
WireConnection;155;1;141;0
WireConnection;197;0;157;0
WireConnection;197;1;199;0
WireConnection;174;0;171;0
WireConnection;174;1;173;0
WireConnection;130;0;113;0
WireConnection;137;0;126;0
WireConnection;137;1;135;0
WireConnection;137;2;138;0
WireConnection;0;0;162;0
WireConnection;0;1;131;0
WireConnection;0;2;191;0
WireConnection;0;10;73;0
WireConnection;0;11;197;0
ASEEND*/
//CHKSM=195B1D2725352660F030B0BD46A6E10F49EE00F6