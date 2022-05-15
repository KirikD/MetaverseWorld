// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASESampleShaders/Community/GlowSummetry"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_DisolveGuide1("Disolve Guide1", 2D) = "white" {}
		_DisolveGuide2("Disolve Guide2", 2D) = "white" {}
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		_Displace("Displace", Range( -0.5 , 0.5)) = 0
		_DisplOfset("DisplOfset", Range( -1 , 1)) = -0.1
		_AnimDivB("AnimDivB", Range( -1 , 1)) = 0.11
		_AnimDivA("AnimDivA", Range( -1 , 1)) = 0.04
		_TilingScalBurn("TilingScalBurn", Vector) = (0,0,0,0)
		_InsideGlow("InsideGlow", Color) = (0,0.6037736,0.4218836,1)
		_AddminusAA("AddminusAA", Float) = 1
		_minusAA("minusAA", Float) = -1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _DissolveAmount;
		uniform sampler2D _DisolveGuide1;
		uniform float2 _TilingScalBurn;
		uniform float _AnimDivA;
		uniform sampler2D _DisolveGuide2;
		uniform float _AnimDivB;
		uniform float _DisplOfset;
		uniform float _Displace;
		uniform sampler2D _Normal;
		uniform sampler2D _Albedo;
		uniform float4 _InsideGlow;
		uniform float _minusAA;
		uniform float _AddminusAA;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float temp_output_146_0 = ( _Time.y * _AnimDivA );
			float2 appendResult141 = (float2(temp_output_146_0 , temp_output_146_0));
			float2 uv_TexCoord155 = v.texcoord.xy * _TilingScalBurn + appendResult141;
			float4 tex2DNode2 = tex2Dlod( _DisolveGuide1, float4( uv_TexCoord155, 0, 1.0) );
			float temp_output_152_0 = ( _Time.y * _AnimDivB );
			float2 appendResult153 = (float2(temp_output_152_0 , temp_output_152_0));
			float2 uv_TexCoord154 = v.texcoord.xy * _TilingScalBurn + appendResult153;
			float4 tex2DNode156 = tex2Dlod( _DisolveGuide2, float4( uv_TexCoord154, 0, 1.0) );
			float temp_output_73_0 = ( (-0.6 + (( 1.0 - _DissolveAmount ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2DNode2.r + tex2DNode156.r + _DisplOfset );
			v.vertex.xyz += ( ase_worldNormal * temp_output_73_0 * _Displace );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_146_0 = ( _Time.y * _AnimDivA );
			float2 appendResult141 = (float2(temp_output_146_0 , temp_output_146_0));
			float2 uv_TexCoord155 = i.uv_texcoord * _TilingScalBurn + appendResult141;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_TexCoord155 ) );
			o.Albedo = tex2D( _Albedo, uv_TexCoord155 ).rgb;
			float4 tex2DNode2 = tex2D( _DisolveGuide1, uv_TexCoord155 );
			float temp_output_152_0 = ( _Time.y * _AnimDivB );
			float2 appendResult153 = (float2(temp_output_152_0 , temp_output_152_0));
			float2 uv_TexCoord154 = i.uv_texcoord * _TilingScalBurn + appendResult153;
			float4 tex2DNode156 = tex2D( _DisolveGuide2, uv_TexCoord154 );
			o.Emission = ( ( _InsideGlow * ( tex2DNode2.r + tex2DNode156.r ) * _minusAA ) + _AddminusAA ).rgb;
			float temp_output_162_0 = 1.0;
			o.Metallic = temp_output_162_0;
			o.Smoothness = temp_output_162_0;
			o.Alpha = 1;
			clip( temp_output_162_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
156;959;1514;579;462.6824;-284.3462;1;True;True
Node;AmplifyShaderEditor.SimpleTimeNode;151;-1950.475,937.7513;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-1761.041,-199.3391;Inherit;False;Property;_AnimDivA;AnimDivA;11;0;Create;True;0;0;0;False;0;False;0.04;0.04;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-2102.438,1063.072;Inherit;False;Property;_AnimDivB;AnimDivB;10;0;Create;True;0;0;0;False;0;False;0.11;0.11;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;140;-1792.915,-361.7525;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-1778.601,985.1647;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-1621.041,-314.3391;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;161;-1696.415,570.5983;Inherit;False;Property;_TilingScalBurn;TilingScalBurn;13;0;Create;True;0;0;0;False;0;False;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;153;-1609.251,901.1908;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;128;-967.3727,510.0833;Inherit;False;908.2314;498.3652;Dissolve - Opacity Mask;6;4;71;2;73;111;159;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;141;-1451.691,-398.313;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-919.0424,582.2975;Float;False;Property;_DissolveAmount;Dissolve Amount;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;154;-1368.027,836.1691;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;155;-1255.779,-427.0171;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;71;-655.2471,583.1434;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-660.3626,761.1237;Inherit;True;Property;_DisolveGuide1;Disolve Guide1;4;0;Create;True;0;0;0;False;0;False;-1;0bbd24355cfb3074392f4e25176bc9da;b3792c50aed9465489732cb8962693ec;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;156;-608.3788,968.3122;Inherit;True;Property;_DisolveGuide2;Disolve Guide2;5;0;Create;True;0;0;0;False;0;False;-1;0bbd24355cfb3074392f4e25176bc9da;b3792c50aed9465489732cb8962693ec;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;167;-139.0986,464.6118;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;169;-134.6976,216.4215;Inherit;False;Property;_InsideGlow;InsideGlow;14;0;Create;True;0;0;0;False;0;False;0,0.6037736,0.4218836,1;1,0.7803586,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;111;-526.4305,583.9279;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;158;-272.7136,1060.284;Inherit;False;Property;_DisplOfset;DisplOfset;9;0;Create;True;0;0;0;False;0;False;-0.1;-0.1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;165;-1.838805,530.0619;Inherit;False;Property;_minusAA;minusAA;16;0;Create;True;0;0;0;False;0;False;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;129;-892.9326,49.09825;Inherit;False;825.9389;437.7136;Burn Effect - Emission;6;130;115;114;126;112;113;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;166;225.1613,487.0619;Inherit;False;Property;_AddminusAA;AddminusAA;15;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-57.08832,1141.994;Float;False;Property;_Displace;Displace;8;0;Create;True;0;0;0;False;0;False;0;0.155;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;132;144.1929,26.72195;Inherit;False;765.1592;493.9802;Created by The Four Headed Cat @fourheadedcat - www.twitter.com/fourheadedcat;3;0;162;164;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;159;-223.7089,779.849;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-261.8102,606.1544;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;74.28468,335.2256;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;114;-422.1431,295.0128;Inherit;True;Property;_BurnRamp;Burn Ramp;6;0;Create;True;0;0;0;False;0;False;-1;None;96789baf9ef4a054c9ec5a94a71a87d1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;130;-627.5982,83.10277;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;112;-878.1525,280.8961;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-4;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;138;-681.1285,-486.5723;Inherit;False;Property;_MullCol;MullCol;12;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;131;-325.7014,-151.4965;Inherit;True;Property;_Normal;Normal;3;0;Create;True;0;0;0;False;0;False;-1;None;8178c5ce4aa3d5341804ce7d0ff18428;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;222.6332,641.806;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-202.3633,125.7657;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;78;-195.8022,-593.1658;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;162;250.9523,191.9833;Inherit;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;164;309.2553,324.5994;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;113;-797.634,90.31517;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;135;-943.4896,-285.8141;Inherit;True;Property;_EmissA;EmissA;2;0;Create;True;0;0;0;False;0;False;-1;None;fbfb5478b78c86e499b5a5921c03b559;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;115;-610.9893,313.0966;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;137;10.79348,84.1115;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;538.637,87.61272;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ASESampleShaders/Community/GlowSummetry;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;152;0;151;0
WireConnection;152;1;150;0
WireConnection;146;0;140;0
WireConnection;146;1;144;0
WireConnection;153;0;152;0
WireConnection;153;1;152;0
WireConnection;141;0;146;0
WireConnection;141;1;146;0
WireConnection;154;0;161;0
WireConnection;154;1;153;0
WireConnection;155;0;161;0
WireConnection;155;1;141;0
WireConnection;71;0;4;0
WireConnection;2;1;155;0
WireConnection;156;1;154;0
WireConnection;167;0;2;1
WireConnection;167;1;156;1
WireConnection;111;0;71;0
WireConnection;73;0;111;0
WireConnection;73;1;2;1
WireConnection;73;2;156;1
WireConnection;73;3;158;0
WireConnection;163;0;169;0
WireConnection;163;1;167;0
WireConnection;163;2;165;0
WireConnection;114;1;115;0
WireConnection;130;0;113;0
WireConnection;112;0;73;0
WireConnection;131;1;155;0
WireConnection;157;0;159;0
WireConnection;157;1;73;0
WireConnection;157;2;160;0
WireConnection;126;0;130;0
WireConnection;126;1;114;0
WireConnection;78;1;155;0
WireConnection;164;0;163;0
WireConnection;164;1;166;0
WireConnection;113;0;112;0
WireConnection;135;1;155;0
WireConnection;115;0;130;0
WireConnection;137;0;126;0
WireConnection;137;1;135;0
WireConnection;137;2;138;0
WireConnection;0;0;78;0
WireConnection;0;1;131;0
WireConnection;0;2;164;0
WireConnection;0;3;162;0
WireConnection;0;4;162;0
WireConnection;0;10;162;0
WireConnection;0;11;157;0
ASEEND*/
//CHKSM=B556A40357FFEAF02DA10DC92C016A6EF713B8D3