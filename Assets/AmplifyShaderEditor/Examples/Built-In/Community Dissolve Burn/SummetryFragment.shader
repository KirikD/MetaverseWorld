// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASESampleShaders/Community/SummetryFragment"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_CheckersScal("CheckersScal", Vector) = (8,6,0,0)
		_CheckersA("CheckersA", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_DisolveGuide1("Disolve Guide1", 2D) = "white" {}
		_CheckersB("CheckersB", 2D) = "white" {}
		_DisolveGuide2("Disolve Guide2", 2D) = "white" {}
		_CutoutScale("CutoutScale", Range( 0 , 9)) = 0
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		_BitHighMinScale("BitHighMinScale", Range( -1 , 6)) = 0.23
		_Displace("Displace", Range( -0.5 , 0.5)) = 0
		_BitB("BitB", Range( 0 , 2)) = 0
		_BitA("BitA", Range( 0 , 2)) = 0
		_DisplOfset("DisplOfset", Range( -1 , 1)) = -0.1
		_AnimDivB("AnimDivB", Range( -1 , 1)) = 0.11
		_AnimDivA("AnimDivA", Range( -1 , 1)) = 0.04
		_MullCol("MullCol", Color) = (0,0,0,0)
		_TilingScalBurn("TilingScalBurn", Vector) = (0,0,0,0)
		_EmisColorMul("EmisColorMul", Float) = 0
		_EmisAdd("EmisAdd", Float) = 0
		_BitCol("BitCol", Color) = (0,0,0,0)
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
		uniform float _BitA;
		uniform sampler2D _DisolveGuide2;
		uniform float _AnimDivB;
		uniform float _DisplOfset;
		uniform float _Displace;
		uniform sampler2D _CheckersA;
		uniform float2 _CheckersScal;
		uniform float _BitHighMinScale;
		uniform sampler2D _CheckersB;
		uniform float _BitB;
		uniform float4 _MullCol;
		uniform float _EmisColorMul;
		uniform float4 _BitCol;
		uniform float _EmisAdd;
		uniform sampler2D _Normal;
		uniform float _CutoutScale;
		uniform float _Cutoff = 0.5;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float temp_output_146_0 = ( _Time.y * _AnimDivA );
			float2 appendResult141 = (float2(temp_output_146_0 , temp_output_146_0));
			float2 uv_TexCoord155 = v.texcoord.xy * _TilingScalBurn + appendResult141;
			float2 temp_output_174_0 = ( uv_TexCoord155 + ( _BitA * -1.0 ) );
			float temp_output_152_0 = ( _Time.y * _AnimDivB );
			float2 appendResult153 = (float2(temp_output_152_0 , temp_output_152_0));
			float2 uv_TexCoord154 = v.texcoord.xy * _TilingScalBurn + appendResult153;
			float temp_output_73_0 = ( (-0.6 + (( 1.0 - _DissolveAmount ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2Dlod( _DisolveGuide1, float4( temp_output_174_0, 0, 1.0) ).r + tex2Dlod( _DisolveGuide2, float4( ( uv_TexCoord154 + _BitA ), 0, 1.0) ).r + _DisplOfset );
			float4 temp_output_210_0 = ( ( tex2Dlod( _CheckersA, float4( ( v.texcoord.xy * _CheckersScal * ( _SinTime.x + _BitHighMinScale ) * _BitA ), 0, 0.0) ) + tex2Dlod( _CheckersB, float4( ( v.texcoord.xy * _CheckersScal * ( _CosTime.x + _BitHighMinScale ) * _BitA ), 0, 0.0) ) ) * _BitB * 5.0 );
			v.vertex.xyz += ( float4( ase_vertexNormal , 0.0 ) * temp_output_73_0 * _Displace * ( ( temp_output_210_0 * _MullCol * temp_output_73_0 * _EmisColorMul ) + _BitCol + _EmisAdd ) ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_146_0 = ( _Time.y * _AnimDivA );
			float2 appendResult141 = (float2(temp_output_146_0 , temp_output_146_0));
			float2 uv_TexCoord155 = i.uv_texcoord * _TilingScalBurn + appendResult141;
			float2 temp_output_174_0 = ( uv_TexCoord155 + ( _BitA * -1.0 ) );
			o.Normal = UnpackNormal( tex2D( _Normal, temp_output_174_0 ) );
			float3 hsvTorgb3_g1 = HSVToRGB( float3(( _BitB * 50.0 ),1.0,1.0) );
			float temp_output_152_0 = ( _Time.y * _AnimDivB );
			float2 appendResult153 = (float2(temp_output_152_0 , temp_output_152_0));
			float2 uv_TexCoord154 = i.uv_texcoord * _TilingScalBurn + appendResult153;
			float temp_output_73_0 = ( (-0.6 + (( 1.0 - _DissolveAmount ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2D( _DisolveGuide1, temp_output_174_0 ).r + tex2D( _DisolveGuide2, ( uv_TexCoord154 + _BitA ) ).r + _DisplOfset );
			float4 temp_output_210_0 = ( ( tex2D( _CheckersA, ( i.uv_texcoord * _CheckersScal * ( _SinTime.x + _BitHighMinScale ) * _BitA ) ) + tex2D( _CheckersB, ( i.uv_texcoord * _CheckersScal * ( _CosTime.x + _BitHighMinScale ) * _BitA ) ) ) * _BitB * 5.0 );
			float4 temp_output_164_0 = ( _MullCol * ( ( float4( hsvTorgb3_g1 , 0.0 ) * _BitCol ) + _BitCol ) * temp_output_73_0 * _EmisColorMul * temp_output_210_0 );
			float4 temp_output_165_0 = ( temp_output_164_0 + _EmisAdd );
			o.Albedo = temp_output_165_0.rgb;
			o.Emission = temp_output_165_0.rgb;
			float temp_output_162_0 = 0.0;
			o.Metallic = temp_output_162_0;
			o.Smoothness = temp_output_162_0;
			o.Alpha = 1;
			clip( ( (-0.6 + (( 1.0 - _CutoutScale ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + temp_output_164_0 ).r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;350;1571;1029;601.6837;87.63943;1.2247;False;True
Node;AmplifyShaderEditor.SimpleTimeNode;151;-1950.475,937.7513;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;140;-1792.915,-361.7525;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-2124.146,1027.363;Inherit;False;Property;_AnimDivB;AnimDivB;16;0;Create;True;0;0;0;False;0;False;0.11;0.11;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-1761.041,-199.3391;Inherit;False;Property;_AnimDivA;AnimDivA;17;0;Create;True;0;0;0;False;0;False;0.04;0.04;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-1778.601,985.1647;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-1621.041,-314.3391;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosTime;190;-1367.662,2001.014;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;191;-1011.196,1632.519;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;189;-1956.256,1756.961;Inherit;False;Property;_BitHighMinScale;BitHighMinScale;11;0;Create;True;0;0;0;False;0;False;0.23;-0.13;-1;6;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;169;-1422.504,1026.909;Float;False;Property;_BitA;BitA;14;0;Create;True;0;0;0;False;0;False;0;0.1884766;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;194;-1518.97,1772.909;Float;False;Property;_CheckersScal;CheckersScal;1;0;Create;True;0;0;0;False;0;False;8,6;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;193;-806.3335,1572.61;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;203;-1542.001,1415.092;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;141;-1451.691,-398.313;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;128;-967.3727,510.0833;Inherit;False;908.2314;498.3652;Dissolve - Opacity Mask;6;4;71;2;73;111;159;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;192;-1021.177,1933.695;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;153;-1609.251,901.1908;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;161;-1696.415,570.5983;Inherit;False;Property;_TilingScalBurn;TilingScalBurn;19;0;Create;True;0;0;0;False;0;False;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;172;-16.86176,1555.085;Float;False;Property;_BitB;BitB;13;0;Create;True;0;0;0;False;0;False;0;0.190918;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;155;-1255.779,-427.0171;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;-1324.963,-88.77301;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1031.043,586.8975;Float;False;Property;_DissolveAmount;Dissolve Amount;10;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;154;-1408.689,907.8113;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;-838.361,1417.457;Inherit;False;4;4;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;215;434.1992,1666.742;Inherit;False;Constant;_Float2;Float 2;22;0;Create;True;0;0;0;False;0;False;50;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;-817.5795,1823.388;Inherit;False;4;4;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;129;-892.9326,49.09825;Inherit;False;814.5701;432.0292;Burn Effect - Emission;6;113;115;114;112;130;212;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;213;543.8148,1570.422;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;197;-409.4894,1352.497;Inherit;True;Property;_CheckersA;CheckersA;3;0;Create;True;0;0;0;False;0;False;-1;None;1f2afebdae360f8499fce6f2be367b32;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;173;-984.0581,1003.268;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;174;-991.7861,-357.3121;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;196;-398.7231,1655.732;Inherit;True;Property;_CheckersB;CheckersB;6;0;Create;True;0;0;0;False;0;False;-1;None;a61151a08d8413b4585e30c14c713e3d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;71;-655.2471,583.1434;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-660.3626,761.1237;Inherit;True;Property;_DisolveGuide1;Disolve Guide1;5;0;Create;True;0;0;0;False;0;False;-1;0bbd24355cfb3074392f4e25176bc9da;1daf96d9aee79bf4b93fa5ea981aaf4b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;212;-307.1054,99.0428;Inherit;False;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.SamplerNode;156;-608.3788,968.3122;Inherit;True;Property;_DisolveGuide2;Disolve Guide2;7;0;Create;True;0;0;0;False;0;False;-1;0bbd24355cfb3074392f4e25176bc9da;1daf96d9aee79bf4b93fa5ea981aaf4b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;201;22.62716,1310.901;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;158;-272.7136,1060.284;Inherit;False;Property;_DisplOfset;DisplOfset;15;0;Create;True;0;0;0;False;0;False;-0.1;-0.64;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;111;-499.1306,589.1279;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;220;-655.4344,-162.2638;Inherit;False;Property;_BitCol;BitCol;22;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.4528302,0.249911,0.3604442,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;211;426.5817,1473.232;Inherit;False;Constant;_Float1;Float 1;22;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;166;-122.4375,268.0319;Inherit;False;Property;_EmisColorMul;EmisColorMul;20;0;Create;True;0;0;0;False;0;False;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-297.5844,584.6297;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;132;144.1929,26.72195;Inherit;False;765.1592;493.9802;Created by The Four Headed Cat @fourheadedcat - www.twitter.com/fourheadedcat;6;0;162;164;165;167;205;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;198.9288,1310.01;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;206;372.3355,753.7632;Float;False;Property;_CutoutScale;CutoutScale;9;0;Create;True;0;0;0;False;0;False;0;0;0;9;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;138;-517.5696,-82.1227;Inherit;False;Property;_MullCol;MullCol;18;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.3632075,0.6407005,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;217;-210.8075,-116.1891;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;207;627.0197,636.5134;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;383.2947,397.0758;Inherit;False;Property;_EmisAdd;EmisAdd;21;0;Create;True;0;0;0;False;0;False;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;219;-28.75082,-48.47293;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;223;368.101,519.6074;Inherit;False;4;4;0;COLOR;1,1,1,1;False;1;COLOR;1,1,1,1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;222;559.3588,504.3327;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;221;-201.4766,687.2737;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;208;783.1361,642.498;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-299.3773,1152.463;Float;False;Property;_Displace;Displace;12;0;Create;True;0;0;0;False;0;False;0;0.06;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;177.6048,78.78971;Inherit;False;5;5;0;COLOR;1,1,1,1;False;1;COLOR;1,1,1,1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;165;445.9835,99.0813;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;130;-627.5982,83.10277;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;115;-610.9893,313.0966;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;131;-202.3178,-297.9297;Inherit;True;Property;_Normal;Normal;4;0;Create;True;0;0;0;False;0;False;-1;None;0bebe40e9ebbecc48b8e9cfea982da7e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;162;223.8745,271.3702;Inherit;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;78;-195.8022,-593.1658;Inherit;True;Property;_Albedo;Albedo;2;0;Create;True;0;0;0;False;0;False;-1;None;e5cd7dc224030cf42872339fb3d1d899;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;198;-1785.868,1534.778;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;199;-1529.868,1534.778;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;159;-60.68732,773.8665;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;112;-878.1525,280.8961;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-4;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;-422.1431,295.0128;Inherit;True;Property;_BurnRamp;Burn Ramp;8;0;Create;True;0;0;0;False;0;False;-1;None;4855cd84f5ba0c344b80c8009ce51491;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;113;-797.634,90.31517;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;205;614.4211,312.8259;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;742.8835,410.3776;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;905.7252,97.05418;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ASESampleShaders/Community/SummetryFragment;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;152;0;151;0
WireConnection;152;1;150;0
WireConnection;146;0;140;0
WireConnection;146;1;144;0
WireConnection;193;0;191;1
WireConnection;193;1;189;0
WireConnection;141;0;146;0
WireConnection;141;1;146;0
WireConnection;192;0;190;1
WireConnection;192;1;189;0
WireConnection;153;0;152;0
WireConnection;153;1;152;0
WireConnection;155;0;161;0
WireConnection;155;1;141;0
WireConnection;209;0;169;0
WireConnection;154;0;161;0
WireConnection;154;1;153;0
WireConnection;200;0;203;0
WireConnection;200;1;194;0
WireConnection;200;2;193;0
WireConnection;200;3;169;0
WireConnection;195;0;203;0
WireConnection;195;1;194;0
WireConnection;195;2;192;0
WireConnection;195;3;169;0
WireConnection;213;0;172;0
WireConnection;213;1;215;0
WireConnection;197;1;200;0
WireConnection;173;0;154;0
WireConnection;173;1;169;0
WireConnection;174;0;155;0
WireConnection;174;1;209;0
WireConnection;196;1;195;0
WireConnection;71;0;4;0
WireConnection;2;1;174;0
WireConnection;212;1;213;0
WireConnection;156;1;173;0
WireConnection;201;0;197;0
WireConnection;201;1;196;0
WireConnection;111;0;71;0
WireConnection;73;0;111;0
WireConnection;73;1;2;1
WireConnection;73;2;156;1
WireConnection;73;3;158;0
WireConnection;210;0;201;0
WireConnection;210;1;172;0
WireConnection;210;2;211;0
WireConnection;217;0;212;6
WireConnection;217;1;220;0
WireConnection;207;0;206;0
WireConnection;219;0;217;0
WireConnection;219;1;220;0
WireConnection;223;0;210;0
WireConnection;223;1;138;0
WireConnection;223;2;73;0
WireConnection;223;3;166;0
WireConnection;222;0;223;0
WireConnection;222;1;220;0
WireConnection;222;2;167;0
WireConnection;208;0;207;0
WireConnection;164;0;138;0
WireConnection;164;1;219;0
WireConnection;164;2;73;0
WireConnection;164;3;166;0
WireConnection;164;4;210;0
WireConnection;165;0;164;0
WireConnection;165;1;167;0
WireConnection;130;0;113;0
WireConnection;115;0;130;0
WireConnection;131;1;174;0
WireConnection;78;1;174;0
WireConnection;199;0;198;0
WireConnection;112;0;73;0
WireConnection;114;1;115;0
WireConnection;113;0;112;0
WireConnection;205;0;208;0
WireConnection;205;1;164;0
WireConnection;157;0;221;0
WireConnection;157;1;73;0
WireConnection;157;2;160;0
WireConnection;157;3;222;0
WireConnection;0;0;165;0
WireConnection;0;1;131;0
WireConnection;0;2;165;0
WireConnection;0;3;162;0
WireConnection;0;4;162;0
WireConnection;0;10;205;0
WireConnection;0;11;157;0
ASEEND*/
//CHKSM=4C4AB9918496C80AEAF2723A9EB2376D01D6F06E