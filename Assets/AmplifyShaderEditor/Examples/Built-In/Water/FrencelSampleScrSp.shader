// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASESampleShaders/Water/FrencelSampleScrSp"
{
	Properties
	{
		_WaterNormal("Water Normal", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_NormalScale("Normal Scale", Float) = 0
		_DisolveGuide1("Disolve Guide1", 2D) = "white" {}
		_FrencelNoiseA("FrencelNoiseA", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_FrencelNoiseB("FrencelNoiseB", 2D) = "white" {}
		_WaterSpecular("Water Specular", Float) = 0
		_Foam("Foam", 2D) = "white" {}
		_FoamDepth("Foam Depth", Float) = 0
		_FoamFalloff("Foam Falloff", Float) = 0
		_AnimDivBB("AnimDivBB", Range( -1 , 1)) = 0.15
		_AnimDivB("AnimDivB", Range( -1 , 1)) = 0.15
		_FoamSpecular("Foam Specular", Float) = 0
		_AnimDivCC("AnimDivCC", Range( -1 , 1)) = 0.15
		_AnimDivC("AnimDivC", Range( -1 , 1)) = 0.15
		_Frenc("Frenc", Color) = (0,0,0,0)
		_FrMul("FrMul", Float) = 44
		_CounturMultiple("CounturMultiple", Float) = 0
		_DisplaceVal("DisplaceVal", Range( 0 , 1)) = 0
		_DisplaceValMinuss("DisplaceValMinuss", Float) = 0
		_FrencelNoiseMinus("FrencelNoiseMinus", Range( -5 , 5)) = -0.5
		_FrencelNoiseMult("FrencelNoiseMult", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha , One One
		BlendOp Add , Add
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			half3 worldNormal;
			INTERNAL_DATA
			float4 screenPos;
		};

		uniform sampler2D _DisolveGuide1;
		uniform half _AnimDivB;
		uniform sampler2D _TextureSample0;
		uniform half _AnimDivC;
		uniform half _DisplaceValMinuss;
		uniform half _DisplaceVal;
		uniform sampler2D _WaterNormal;
		uniform float4 _WaterNormal_ST;
		uniform float _NormalScale;
		uniform half4 _Frenc;
		uniform half _FrMul;
		uniform half _CounturMultiple;
		uniform float _WaterSpecular;
		uniform float _FoamSpecular;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _FoamDepth;
		uniform float _FoamFalloff;
		uniform sampler2D _Foam;
		uniform float4 _Foam_ST;
		uniform half _FrencelNoiseMinus;
		uniform sampler2D _FrencelNoiseA;
		uniform half _AnimDivBB;
		uniform sampler2D _FrencelNoiseB;
		uniform half _AnimDivCC;
		uniform half _FrencelNoiseMult;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			half3 ase_vertexNormal = v.normal.xyz;
			float4 ase_vertex4Pos = v.vertex;
			half4 unityObjectToClipPos195 = UnityObjectToClipPos( ase_vertex4Pos.xyz );
			half4 computeScreenPos191 = ComputeScreenPos( unityObjectToClipPos195 );
			half4 temp_output_198_0 = ( computeScreenPos191 / (computeScreenPos191).z );
			half4 temp_output_204_0 = ( temp_output_198_0 * 0.1 );
			half temp_output_190_0 = ( 0.0 + tex2Dlod( _DisolveGuide1, float4( ( temp_output_204_0 + 99.0 + ( _SinTime.x * _AnimDivB ) ).xy, 0, 1.0) ).r + tex2Dlod( _TextureSample0, float4( ( temp_output_204_0 + 99.0 + ( _CosTime.x * _AnimDivC ) ).xy, 0, 1.0) ).r );
			v.vertex.xyz += ( ase_vertexNormal * ( temp_output_190_0 + _DisplaceValMinuss ) * _DisplaceVal );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_WaterNormal = i.uv_texcoord * _WaterNormal_ST.xy + _WaterNormal_ST.zw;
			half2 panner22 = ( 1.0 * _Time.y * float2( -0.03,0 ) + uv_WaterNormal);
			half2 panner19 = ( 1.0 * _Time.y * float2( 0.04,0.04 ) + uv_WaterNormal);
			half3 temp_output_24_0 = BlendNormals( UnpackScaleNormal( tex2D( _WaterNormal, panner22 ), _NormalScale ) , tex2D( _WaterNormal, panner19 ).rgb );
			o.Normal = temp_output_24_0;
			float3 ase_worldPos = i.worldPos;
			half3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			half3 ase_worldNormal = WorldNormalVector( i, half3( 0, 0, 1 ) );
			half fresnelNdotV167 = dot( ase_worldNormal, ase_worldViewDir );
			half fresnelNode167 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV167, 5.0 ) );
			half4 clampResult171 = clamp( ( _Frenc * ( floor( ( fresnelNode167 * _FrMul ) ) * 9.0 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			half4 temp_output_182_0 = ( clampResult171 + float4( 0,0,0,0 ) );
			half4 temp_output_213_0 = ( temp_output_182_0 * _CounturMultiple );
			o.Albedo = temp_output_213_0.rgb;
			o.Emission = temp_output_213_0.rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			half eyeDepth1 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half temp_output_89_0 = abs( ( eyeDepth1 - ase_screenPos.w ) );
			float2 uv_Foam = i.uv_texcoord * _Foam_ST.xy + _Foam_ST.zw;
			half2 panner116 = ( 1.0 * _Time.y * float2( -0.01,0.01 ) + uv_Foam);
			half temp_output_114_0 = ( saturate( pow( ( temp_output_89_0 + _FoamDepth ) , _FoamFalloff ) ) * tex2D( _Foam, panner116 ).r );
			half lerpResult130 = lerp( _WaterSpecular , _FoamSpecular , temp_output_114_0);
			half3 temp_cast_3 = (lerpResult130).xxx;
			o.Specular = temp_cast_3;
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			half4 unityObjectToClipPos220 = UnityObjectToClipPos( ase_vertex4Pos.xyz );
			half4 computeScreenPos221 = ComputeScreenPos( unityObjectToClipPos220 );
			half4 temp_output_227_0 = ( computeScreenPos221 / (computeScreenPos221).z );
			half4 temp_output_229_0 = ( temp_output_227_0 * 0.1 );
			half4 temp_output_241_0 = ( temp_output_182_0 * ( ( _FrencelNoiseMinus + tex2D( _FrencelNoiseA, ( temp_output_229_0 + 99.0 + ( _SinTime.x * _AnimDivBB ) ).xy ).r + tex2D( _FrencelNoiseB, ( temp_output_229_0 + 99.0 + ( _CosTime.x * _AnimDivCC ) ).xy ).r ) * _FrencelNoiseMult ) );
			o.Alpha = temp_output_241_0.r;
			clip( temp_output_241_0.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
413;464;1571;915;-1925.735;1978.852;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;152;-2053.601,-256.6997;Inherit;False;843.903;553.8391;Screen depth difference to get intersection and fading effect with terrain and objects;5;89;3;1;2;166;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;166;-2010.745,-176.8604;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;194;764.5817,565.7001;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;240;1905.803,-1971.634;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;195;1008.797,550.4606;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-1993.601,-9.1996;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;1;-1781.601,-155.6997;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;220;2150.018,-1986.874;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;191;1206.897,569.4786;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-1574.201,-110.3994;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;221;2348.118,-1967.856;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;222;2341.719,-1812.872;Inherit;False;False;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;89;-1389.004,-112.5834;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;175;921.613,-615.5303;Inherit;False;Property;_FrMul;FrMul;24;0;Create;True;0;0;0;False;0;False;44;1.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;196;1200.498,724.4623;Inherit;False;False;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;167;652.6469,-723.6737;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;226;2545.427,-1763.053;Inherit;False;Constant;_Float5;Float 5;10;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;2351.024,-1283.557;Inherit;False;Property;_AnimDivCC;AnimDivCC;20;0;Create;True;0;0;0;False;0;False;0.15;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;202;1404.206,774.2817;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;223;2377.037,-1704.426;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;153;-843.9032,402.718;Inherit;False;1083.102;484.2006;Foam controls and texture;9;116;105;106;115;111;110;112;113;114;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;155;-1106.507,7.515848;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;983.613,-737.5303;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;225;2375.447,-1542.623;Inherit;False;Property;_AnimDivBB;AnimDivBB;17;0;Create;True;0;0;0;False;0;False;0.15;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;197;1235.816,832.9081;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;199;1209.803,1253.777;Inherit;False;Property;_AnimDivC;AnimDivC;21;0;Create;True;0;0;0;False;0;False;0.15;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;227;2551.04,-1869.202;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CosTime;228;2330.634,-1429.148;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;198;1409.819,668.1321;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CosTime;201;1189.413,1108.186;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;200;1234.226,994.7119;Inherit;False;Property;_AnimDivB;AnimDivB;18;0;Create;True;0;0;0;False;0;False;0.15;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;206;1429.01,895.0834;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;207;1555.35,1045.064;Inherit;False;Constant;_Float3;Float 3;10;0;Create;True;0;0;0;False;0;False;99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;170;1124.508,-536.756;Inherit;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;0;False;0;False;9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-722.2024,526.6185;Float;False;Property;_FoamDepth;Foam Depth;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;154;-922.7065,390.316;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;205;1555.773,942.9989;Inherit;False;Constant;_Float4;Float 4;10;0;Create;True;0;0;0;False;0;False;99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;1565.206,656.2817;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;230;2548.808,-1408.185;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;232;2696.994,-1594.336;Inherit;False;Constant;_Float6;Float 6;10;0;Create;True;0;0;0;False;0;False;99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;2706.427,-1881.053;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;231;2570.231,-1642.251;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;203;1407.587,1129.149;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;174;1156.613,-715.5303;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;233;2696.571,-1492.271;Inherit;False;Constant;_Float7;Float 7;10;0;Create;True;0;0;0;False;0;False;99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;1289.104,-675.3461;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;106;-793.9032,700.119;Inherit;False;0;105;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;112;-531.4025,588.5187;Float;False;Property;_FoamFalloff;Foam Falloff;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;172;1151.126,-432.3254;Inherit;False;Property;_Frenc;Frenc;23;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.1320755,0.02250579,0.006852974,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-542.0016,452.718;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;208;1834.427,1003.657;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;151;-935.9057,-1082.484;Inherit;False;1281.603;457.1994;Blend panning normals to fake noving ripples;7;19;23;24;21;22;17;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;235;2900.211,-1829.968;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;209;1758.99,707.3663;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;234;2975.648,-1533.677;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;192;1977.092,660.5826;Inherit;True;Property;_DisolveGuide1;Disolve Guide1;4;0;Create;True;0;0;0;False;0;False;-1;0bbd24355cfb3074392f4e25176bc9da;1ebab3d74f527a841bf8a652f9787827;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-885.9058,-1005.185;Inherit;False;0;17;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;237;3118.313,-1876.752;Inherit;True;Property;_FrencelNoiseA;FrencelNoiseA;5;0;Create;True;0;0;0;False;0;False;-1;0bbd24355cfb3074392f4e25176bc9da;a61151a08d8413b4585e30c14c713e3d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;1437.848,-684.973;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;193;2034.076,952.7709;Inherit;True;Property;_TextureSample0;Texture Sample 0;8;0;Create;True;0;0;0;False;0;False;-1;0bbd24355cfb3074392f4e25176bc9da;6d95329d56916bc40a104ce96966b296;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;243;3538.173,-1728.395;Inherit;False;Property;_FrencelNoiseMinus;FrencelNoiseMinus;30;0;Create;True;0;0;0;False;0;False;-0.5;-0.63;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;236;3175.297,-1584.564;Inherit;True;Property;_FrencelNoiseB;FrencelNoiseB;9;0;Create;True;0;0;0;False;0;False;-1;0bbd24355cfb3074392f4e25176bc9da;4f2de2830901651419eb727f6b7e6066;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;116;-573.2014,720.3181;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.01,0.01;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;110;-357.2024,461.6185;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;219;1426.449,-194.8039;Inherit;False;Property;_DisplaceValMinuss;DisplaceValMinuss;29;0;Create;True;0;0;0;False;0;False;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;238;3674.838,-1588.035;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;190;2317.77,465.8887;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;105;-304.4021,674.9185;Inherit;True;Property;_Foam;Foam;14;0;Create;True;0;0;0;False;0;False;-1;None;b3792c50aed9465489732cb8962693ec;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;171;1568.604,-680.473;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;19;-610.9061,-919.9849;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;245;3558.411,-1234.032;Inherit;False;Property;_FrencelNoiseMult;FrencelNoiseMult;31;0;Create;True;0;0;0;False;0;False;0;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;113;-136.0011,509.618;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-557.3063,-795.3858;Float;False;Property;_NormalScale;Normal Scale;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;22;-613.2062,-1032.484;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.03,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalVertexDataNode;216;1595.462,-481.0067;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;182;1746.38,-564.3993;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;215;1681.903,-273.1719;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;80.19891,604.0181;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;214;2121.111,-381.0103;Inherit;False;Property;_CounturMultiple;CounturMultiple;27;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;756.1969,-467.1806;Float;False;Property;_FoamSpecular;Foam Specular;19;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;753.9969,-565.4819;Float;False;Property;_WaterSpecular;Water Specular;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;159;-863.7005,-467.5007;Inherit;False;1113.201;508.3005;Depths controls and colors;11;87;94;12;13;156;157;11;88;10;6;143;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;17;-256.3054,-814.2847;Inherit;True;Property;_WaterNormal;Water Normal;0;0;Create;True;0;0;0;False;0;False;-1;None;9a4a55d8d2e54394d97426434477cdcf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;218;1923.362,-262.0585;Inherit;False;Property;_DisplaceVal;DisplaceVal;28;0;Create;True;0;0;0;False;0;False;0;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;246;3762.463,-1393.097;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;150;467.1957,-1501.783;Inherit;False;985.6011;418.6005;Get screen color for refraction and disturbe it with normals;7;96;97;98;65;149;164;165;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;23;-269.2061,-1024.185;Inherit;True;Property;_Normal2;Normal2;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Instance;17;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;185;1524.345,110.5004;Inherit;False;Property;_FrMul2;FrMul2;25;0;Create;True;0;0;0;False;0;False;-44;-44;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-813.7005,-128.1996;Float;False;Property;_WaterDepth;Water Depth;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;710.096,-1203.183;Float;False;Property;_Distortion;Distortion;13;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;65;1232.797,-1350.483;Float;False;Global;_WaterGrab;WaterGrab;-1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;108;58.99682,146.0182;Float;False;Constant;_Color0;Color 0;-1;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;1636.845,-94.29959;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;143;95.69542,-321.0839;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;149;487.4943,-1188.882;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;888.1974,-1279.783;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;11;-455.0999,-328.3;Float;False;Property;_ShalowColor;Shalow Color;6;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;161;660.4934,-750.6837;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;2239.806,-55.77684;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;914.3978,-199.48;Float;False;Property;_FoamSmoothness;Foam Smoothness;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;94;-249.5044,-96.98394;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;1041.296,-1346.683;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-636.2005,-79.20019;Float;False;Property;_WaterFalloff;Water Falloff;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;188;1932.047,5.394813;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;920.1959,-279.1855;Float;False;Property;_WaterSmoothness;Water Smoothness;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;213;1932.151,-683.208;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;13;60.50008,-220.6998;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;183;1372.379,-92.54302;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;187;1804.012,-97.3995;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-697.5002,-417.5007;Float;False;Property;_DeepColor;Deep Color;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;165;814.6503,-1385.291;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;239;2703.427,-1762.053;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;189;1798.357,113.5511;Inherit;False;Constant;_Float1;Float 1;19;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;217;1905.462,-435.0067;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;1562.206,775.2817;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;93;1559.196,-1006.285;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;156;-151.0076,-354.5834;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;157;-149.1077,-261.9834;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;181;1700.824,170.5594;Inherit;True;Property;_AddCol;AddCol;26;0;Create;True;0;0;0;False;0;False;-1;None;96789baf9ef4a054c9ec5a94a71a87d1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;158;-1075.608,-163.0834;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;87;-455.8059,-118.1832;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;164;511.3026,-1442.425;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-632.0056,-204.5827;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;130;955.7971,-465.8806;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;2153.067,-597.6545;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;24;170.697,-879.6849;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;117;323.797,77.91843;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;162;1312.293,-894.3823;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2298.292,-760.5962;Half;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;ASESampleShaders/Water/FrencelSampleScrSp;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;2;5;False;-1;10;False;-1;4;1;False;-1;1;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;195;0;194;0
WireConnection;1;0;166;0
WireConnection;220;0;240;0
WireConnection;191;0;195;0
WireConnection;3;0;1;0
WireConnection;3;1;2;4
WireConnection;221;0;220;0
WireConnection;222;0;221;0
WireConnection;89;0;3;0
WireConnection;196;0;191;0
WireConnection;155;0;89;0
WireConnection;176;0;167;0
WireConnection;176;1;175;0
WireConnection;227;0;221;0
WireConnection;227;1;222;0
WireConnection;198;0;191;0
WireConnection;198;1;196;0
WireConnection;206;0;197;1
WireConnection;206;1;200;0
WireConnection;154;0;155;0
WireConnection;204;0;198;0
WireConnection;204;1;202;0
WireConnection;230;0;228;1
WireConnection;230;1;224;0
WireConnection;229;0;227;0
WireConnection;229;1;226;0
WireConnection;231;0;223;1
WireConnection;231;1;225;0
WireConnection;203;0;201;1
WireConnection;203;1;199;0
WireConnection;174;0;176;0
WireConnection;169;0;174;0
WireConnection;169;1;170;0
WireConnection;115;0;154;0
WireConnection;115;1;111;0
WireConnection;208;0;204;0
WireConnection;208;1;207;0
WireConnection;208;2;203;0
WireConnection;235;0;229;0
WireConnection;235;1;232;0
WireConnection;235;2;231;0
WireConnection;209;0;204;0
WireConnection;209;1;205;0
WireConnection;209;2;206;0
WireConnection;234;0;229;0
WireConnection;234;1;233;0
WireConnection;234;2;230;0
WireConnection;192;1;209;0
WireConnection;237;1;235;0
WireConnection;212;0;172;0
WireConnection;212;1;169;0
WireConnection;193;1;208;0
WireConnection;236;1;234;0
WireConnection;116;0;106;0
WireConnection;110;0;115;0
WireConnection;110;1;112;0
WireConnection;238;0;243;0
WireConnection;238;1;237;1
WireConnection;238;2;236;1
WireConnection;190;1;192;1
WireConnection;190;2;193;1
WireConnection;105;1;116;0
WireConnection;171;0;212;0
WireConnection;19;0;21;0
WireConnection;113;0;110;0
WireConnection;22;0;21;0
WireConnection;182;0;171;0
WireConnection;215;0;190;0
WireConnection;215;1;219;0
WireConnection;114;0;113;0
WireConnection;114;1;105;1
WireConnection;17;1;19;0
WireConnection;246;0;238;0
WireConnection;246;1;245;0
WireConnection;23;1;22;0
WireConnection;23;5;48;0
WireConnection;65;0;96;0
WireConnection;184;0;183;0
WireConnection;184;1;185;0
WireConnection;143;0;94;0
WireConnection;149;0;24;0
WireConnection;98;0;149;0
WireConnection;98;1;97;0
WireConnection;161;0;117;0
WireConnection;186;0;188;0
WireConnection;186;1;190;0
WireConnection;94;0;87;0
WireConnection;96;0;165;0
WireConnection;96;1;98;0
WireConnection;188;0;187;0
WireConnection;213;0;182;0
WireConnection;213;1;214;0
WireConnection;13;0;156;0
WireConnection;13;1;157;0
WireConnection;13;2;94;0
WireConnection;187;0;184;0
WireConnection;187;1;189;0
WireConnection;165;0;164;0
WireConnection;239;0;227;0
WireConnection;239;1;226;0
WireConnection;217;0;216;0
WireConnection;217;1;215;0
WireConnection;217;2;218;0
WireConnection;210;0;198;0
WireConnection;210;1;202;0
WireConnection;93;0;161;0
WireConnection;93;1;65;0
WireConnection;93;2;162;0
WireConnection;156;0;12;0
WireConnection;157;0;11;0
WireConnection;158;0;89;0
WireConnection;87;0;88;0
WireConnection;87;1;10;0
WireConnection;88;0;158;0
WireConnection;88;1;6;0
WireConnection;130;0;104;0
WireConnection;130;1;131;0
WireConnection;130;2;114;0
WireConnection;241;0;182;0
WireConnection;241;1;246;0
WireConnection;24;0;23;0
WireConnection;24;1;17;0
WireConnection;117;0;13;0
WireConnection;117;1;108;0
WireConnection;117;2;114;0
WireConnection;162;0;143;0
WireConnection;0;0;213;0
WireConnection;0;1;24;0
WireConnection;0;2;213;0
WireConnection;0;3;130;0
WireConnection;0;9;241;0
WireConnection;0;10;241;0
WireConnection;0;11;217;0
ASEEND*/
//CHKSM=FB026907323AE4CACCB415B9E1F8D3CF25258373