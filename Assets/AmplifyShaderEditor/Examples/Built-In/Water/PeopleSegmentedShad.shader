// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASESampleShaders/PeopleSegmentedShader"
{
	Properties
	{
		_WaterNormal("Water Normal", 2D) = "bump" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_NormalScale("Normal Scale", Float) = 0
		_FrMulA("FrMulA", Float) = 10
		_FrMulC("FrMulC", Float) = 10
		_FrencelNoiseA1("FrencelNoiseA", 2D) = "white" {}
		_FrMulB("FrMulB", Float) = 10
		_FrMulMinusC("FrMulMinusC", Float) = -2
		_FrMulMinusB("FrMulMinusB", Float) = -2
		_FrMulMinusA("FrMulMinusA", Float) = -2
		_CheckersA("CheckersA", 2D) = "white" {}
		_FrencelNoiseB1("FrencelNoiseB", 2D) = "white" {}
		_FrAddA("FrAddA", Float) = 0
		_FrAddC("FrAddC", Float) = 0
		_FrAddB("FrAddB", Float) = 0
		_DeepColor("Deep Color", Color) = (0,0,0,0)
		_CheckersB("CheckersB", 2D) = "white" {}
		_FrAddMinusA("FrAddMinusA", Float) = 1
		_FrAddMinusC("FrAddMinusC", Float) = 1
		_FrAddMinusB("FrAddMinusB", Float) = 1
		_AnimDivBB1("AnimDivBB", Range( -1 , 1)) = 0.15
		_Albedo("Albedo", 2D) = "white" {}
		_ShalowColor("Shalow Color", Color) = (1,1,1,0)
		_AnimDivCC1("AnimDivCC", Range( -1 , 1)) = 0.15
		_WaterDepth("Water Depth", Float) = 0
		_DisplScal("DisplScal", Float) = 0.1
		_WaterFalloff("Water Falloff", Float) = 0
		_DissolveAmount("Dissolve Amount", Range( -5 , 5)) = 0
		_DissolveMul("DissolveMul", Range( 0 , 10)) = 0
		_WaterSpecular("Water Specular", Float) = 0
		_AnimDivB("AnimDivB", Range( -1 , 1)) = 0.15
		_Distortion("Distortion", Float) = 0.5
		_Foam("Foam", 2D) = "white" {}
		_FrencelNoiseMinus1("FrencelNoiseMinus", Range( -5 , 5)) = -0.5
		_FrencelNoiseMult1("FrencelNoiseMult", Float) = 0
		_AnimDivC("AnimDivC", Range( -1 , 1)) = 0.15
		_FoamDepth("Foam Depth", Float) = 0
		_FoamFalloff("Foam Falloff", Float) = 0
		_FoamSpecular("Foam Specular", Float) = 0
		_Frenc("Frenc", Color) = (0,0,0,0)
		_FrMulEndA("FrMulEndA", Float) = -44
		_FrMulEndB("FrMulEndB", Float) = -44
		_FrMulEndC("FrMulEndC", Float) = -44
		_AddCol("AddCol", 2D) = "white" {}
		_FrColorA("FrColorA", Color) = (1,0.0518868,0.0518868,0)
		_FrColorB("FrColorB", Color) = (1,0.0518868,0.0518868,0)
		_FrColorC("FrColorC", Color) = (1,0.0518868,0.0518868,0)
		_DissloveGlobalScale("DissloveGlobalScale", Float) = 0.21
		_DelRadugaFrencel("DelRadugaFrencel", Range( 0 , 2)) = 0.25
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
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf StandardSpecular keepalpha vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldPos;
			half3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _Albedo;
		uniform half4 _Albedo_ST;
		uniform sampler2D _CheckersA;
		uniform half _DissloveGlobalScale;
		uniform half _AnimDivB;
		uniform sampler2D _CheckersB;
		uniform half _AnimDivC;
		uniform half _DisplScal;
		uniform sampler2D _WaterNormal;
		uniform float4 _WaterNormal_ST;
		uniform float _NormalScale;
		uniform float4 _DeepColor;
		uniform float4 _ShalowColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _WaterDepth;
		uniform float _WaterFalloff;
		uniform float _FoamDepth;
		uniform float _FoamFalloff;
		uniform sampler2D _Foam;
		uniform float4 _Foam_ST;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Distortion;
		uniform sampler2D _AddCol;
		uniform half4 _AddCol_ST;
		uniform half4 _Frenc;
		uniform half _FrMulMinusA;
		uniform half _FrAddMinusA;
		uniform half _FrMulA;
		uniform half _FrAddA;
		uniform half _FrMulEndA;
		uniform half4 _FrColorA;
		uniform float _DissolveAmount;
		uniform float _DissolveMul;
		uniform half _DelRadugaFrencel;
		uniform half _FrMulMinusB;
		uniform half _FrAddMinusB;
		uniform half _FrMulB;
		uniform half _FrAddB;
		uniform half _FrMulEndB;
		uniform half4 _FrColorB;
		uniform half _FrMulMinusC;
		uniform half _FrAddMinusC;
		uniform half _FrMulC;
		uniform half _FrAddC;
		uniform half _FrMulEndC;
		uniform half4 _FrColorC;
		uniform float _WaterSpecular;
		uniform float _FoamSpecular;
		uniform half _FrencelNoiseMinus1;
		uniform sampler2D _FrencelNoiseA1;
		uniform half _AnimDivBB1;
		uniform sampler2D _FrencelNoiseB1;
		uniform half _AnimDivCC1;
		uniform half _FrencelNoiseMult1;
		uniform float _Cutoff = 0.5;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			half3 ase_vertexNormal = v.normal.xyz;
			float2 uv_Albedo = v.texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			half2 temp_cast_1 = (_DissloveGlobalScale).xx;
			half temp_output_262_0 = ( _SinTime.x * _AnimDivB );
			half2 temp_cast_2 = (temp_output_262_0).xx;
			float2 uv_TexCoord337 = v.texcoord.xy * temp_cast_1 + temp_cast_2;
			half2 temp_cast_3 = (_DissloveGlobalScale).xx;
			half temp_output_266_0 = ( _CosTime.x * _AnimDivC );
			half2 temp_cast_4 = (temp_output_266_0).xx;
			float2 uv_TexCoord338 = v.texcoord.xy * temp_cast_3 + temp_cast_4;
			half4 temp_output_246_0 = ( tex2Dlod( _Albedo, float4( uv_Albedo, 0, 0.0) ) * tex2Dlod( _CheckersA, float4( uv_TexCoord337, 0, 0.0) ) * tex2Dlod( _CheckersB, float4( uv_TexCoord338, 0, 0.0) ) );
			v.vertex.xyz += ( half4( ase_vertexNormal , 0.0 ) * temp_output_246_0 * _DisplScal ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_WaterNormal = i.uv_texcoord * _WaterNormal_ST.xy + _WaterNormal_ST.zw;
			half2 panner22 = ( 1.0 * _Time.y * float2( -0.03,0 ) + uv_WaterNormal);
			half2 panner19 = ( 1.0 * _Time.y * float2( 0.04,0.04 ) + uv_WaterNormal);
			half3 temp_output_24_0 = BlendNormals( UnpackScaleNormal( tex2D( _WaterNormal, panner22 ), _NormalScale ) , UnpackNormal( tex2D( _WaterNormal, panner19 ) ) );
			o.Normal = temp_output_24_0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			half eyeDepth1 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half temp_output_89_0 = abs( ( eyeDepth1 - ase_screenPos.w ) );
			half temp_output_94_0 = saturate( pow( ( temp_output_89_0 + _WaterDepth ) , _WaterFalloff ) );
			half4 lerpResult13 = lerp( _DeepColor , _ShalowColor , temp_output_94_0);
			float2 uv_Foam = i.uv_texcoord * _Foam_ST.xy + _Foam_ST.zw;
			half2 panner116 = ( 1.0 * _Time.y * float2( -0.01,0.01 ) + uv_Foam);
			half temp_output_114_0 = ( saturate( pow( ( temp_output_89_0 + _FoamDepth ) , _FoamFalloff ) ) * tex2D( _Foam, panner116 ).r );
			half4 lerpResult117 = lerp( lerpResult13 , float4(1,1,1,0) , temp_output_114_0);
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			half4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor65 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( half3( (ase_grabScreenPosNorm).xy ,  0.0 ) + ( temp_output_24_0 * _Distortion ) ).xy);
			half4 lerpResult93 = lerp( lerpResult117 , screenColor65 , temp_output_94_0);
			o.Albedo = lerpResult93.rgb;
			float2 uv_AddCol = i.uv_texcoord * _AddCol_ST.xy + _AddCol_ST.zw;
			half4 tex2DNode181 = tex2D( _AddCol, uv_AddCol );
			float3 ase_worldPos = i.worldPos;
			half3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			half3 ase_worldNormal = WorldNormalVector( i, half3( 0, 0, 1 ) );
			half fresnelNdotV270 = dot( ase_worldNormal, ase_worldViewDir );
			half fresnelNode270 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV270, 5.0 ) );
			half clampResult279 = clamp( ( ( fresnelNode270 * _FrMulMinusA ) + _FrAddMinusA ) , 0.0 , 10000.0 );
			half clampResult280 = clamp( ( ( fresnelNode270 * _FrMulA ) + _FrAddA ) , 0.0 , 10000.0 );
			half temp_output_281_0 = ( clampResult279 * clampResult280 * _FrMulEndA );
			half4 clampResult171 = clamp( ( _Frenc * temp_output_281_0 * 9.0 ) , float4( 0,0,0,1 ) , float4( 1,1,1,1 ) );
			half3 appendResult193 = (half3(temp_output_281_0 , temp_output_281_0 , temp_output_281_0));
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			half2 temp_cast_4 = (_DissloveGlobalScale).xx;
			half temp_output_262_0 = ( _SinTime.x * _AnimDivB );
			half2 temp_cast_5 = (temp_output_262_0).xx;
			float2 uv_TexCoord337 = i.uv_texcoord * temp_cast_4 + temp_cast_5;
			half2 temp_cast_6 = (_DissloveGlobalScale).xx;
			half temp_output_266_0 = ( _CosTime.x * _AnimDivC );
			half2 temp_cast_7 = (temp_output_266_0).xx;
			float2 uv_TexCoord338 = i.uv_texcoord * temp_cast_6 + temp_cast_7;
			half4 temp_output_246_0 = ( tex2D( _Albedo, uv_Albedo ) * tex2D( _CheckersA, uv_TexCoord337 ) * tex2D( _CheckersB, uv_TexCoord338 ) );
			half4 temp_output_251_0 = ( _DissolveAmount + ( temp_output_246_0 * _DissolveMul ) );
			half4 clampResult284 = clamp( temp_output_251_0 , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			half4 temp_output_335_0 = ( clampResult284 + -0.7 );
			half fresnelNdotV298 = dot( ase_worldNormal, ase_worldViewDir );
			half fresnelNode298 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV298, 5.0 ) );
			half clampResult303 = clamp( ( ( fresnelNode298 * _FrMulMinusB ) + _FrAddMinusB ) , 0.0 , 10000.0 );
			half clampResult304 = clamp( ( ( fresnelNode298 * _FrMulB ) + _FrAddB ) , 0.0 , 10000.0 );
			half temp_output_305_0 = ( clampResult303 * clampResult304 * _FrMulEndB );
			half3 appendResult306 = (half3(temp_output_305_0 , temp_output_305_0 , temp_output_305_0));
			half fresnelNdotV314 = dot( ase_worldNormal, ase_worldViewDir );
			half fresnelNode314 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV314, 5.0 ) );
			half clampResult323 = clamp( ( ( fresnelNode314 * _FrMulMinusC ) + _FrAddMinusC ) , 0.0 , 10000.0 );
			half clampResult324 = clamp( ( ( fresnelNode314 * _FrMulC ) + _FrAddC ) , 0.0 , 10000.0 );
			half temp_output_325_0 = ( clampResult323 * clampResult324 * _FrMulEndC );
			half3 appendResult327 = (half3(temp_output_325_0 , temp_output_325_0 , temp_output_325_0));
			half4 temp_output_182_0 = ( clampResult171 + ( half4( appendResult193 , 0.0 ) * _FrColorA * temp_output_335_0 * _DelRadugaFrencel ) + ( half4( appendResult306 , 0.0 ) * _FrColorB * temp_output_335_0 * _DelRadugaFrencel ) + ( half4( appendResult327 , 0.0 ) * _FrColorC * temp_output_335_0 * _DelRadugaFrencel ) + ( ( ( half4( appendResult193 , 0.0 ) * _FrColorA ) + ( half4( appendResult306 , 0.0 ) * _FrColorB ) + ( half4( appendResult327 , 0.0 ) * _FrColorC ) ) * _DelRadugaFrencel ) );
			o.Emission = ( ( tex2DNode181 * 1.66 ) + temp_output_182_0 ).rgb;
			half lerpResult130 = lerp( _WaterSpecular , _FoamSpecular , temp_output_114_0);
			half3 temp_cast_14 = (lerpResult130).xxx;
			o.Specular = temp_cast_14;
			half4 break197 = temp_output_182_0;
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			half4 unityObjectToClipPos347 = UnityObjectToClipPos( ase_vertex4Pos.xyz );
			half4 computeScreenPos348 = ComputeScreenPos( unityObjectToClipPos347 );
			half4 temp_output_354_0 = ( computeScreenPos348 / (computeScreenPos348).z );
			half4 temp_output_358_0 = ( temp_output_354_0 * 0.19 );
			half clampResult370 = clamp( ( ( _FrencelNoiseMinus1 + tex2D( _FrencelNoiseA1, ( temp_output_358_0 + 99.0 + ( _SinTime.x * _AnimDivBB1 ) ).xy ).r + tex2D( _FrencelNoiseB1, ( temp_output_358_0 + 99.0 + ( _CosTime.x * _AnimDivCC1 ) ).xy ).r ) * _FrencelNoiseMult1 ) , 0.0 , 100.0 );
			half4 clampResult282 = clamp( temp_output_251_0 , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			half4 temp_output_283_0 = ( ( ( break197.r + break197.g + break197.b ) * 1.0 * clampResult370 ) + ( tex2DNode181 * clampResult282 ) );
			o.Alpha = temp_output_283_0.r;
			clip( temp_output_283_0.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
25;500;1571;879;-889.1667;812.1289;1.337191;True;True
Node;AmplifyShaderEditor.RangedFloatNode;259;1290.809,1859.542;Inherit;False;Property;_AnimDivB;AnimDivB;32;0;Create;True;0;0;0;False;0;False;0.15;0.33;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosTime;260;1245.996,1973.016;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;256;1292.399,1697.738;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;261;1266.386,2118.607;Inherit;False;Property;_AnimDivC;AnimDivC;37;0;Create;True;0;0;0;False;0;False;0.15;-0.33;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;329;688.951,900.4106;Inherit;False;Property;_FrMulMinusC;FrMulMinusC;7;0;Create;True;0;0;0;False;0;False;-2;-80;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;339;1659.082,1840.076;Inherit;False;Property;_DissloveGlobalScale;DissloveGlobalScale;52;0;Create;True;0;0;0;False;0;False;0.21;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;270;667.7429,275.0906;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;298;647.6292,625.6698;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;152;-2053.601,-256.6997;Inherit;False;843.903;553.8391;Screen depth difference to get intersection and fading effect with terrain and objects;5;89;3;1;2;166;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FresnelNode;314;635.6244,972.3644;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;315;724.4596,1146.167;Inherit;False;Property;_FrMulC;FrMulC;4;0;Create;True;0;0;0;False;0;False;10;8000;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;309;700.9559,553.716;Inherit;False;Property;_FrMulMinusB;FrMulMinusB;8;0;Create;True;0;0;0;False;0;False;-2;-1990;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;311;683.7038,798.2166;Inherit;False;Property;_FrMulB;FrMulB;6;0;Create;True;0;0;0;False;0;False;10;403999;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;271;668.9074,449.011;Inherit;False;Property;_FrMulA;FrMulA;3;0;Create;True;0;0;0;False;0;False;10;133;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;272;725.7534,189.0855;Inherit;False;Property;_FrMulMinusA;FrMulMinusA;9;0;Create;True;0;0;0;False;0;False;-2;-15.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;1464.17,1993.979;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;1485.593,1759.913;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;275;1089.841,433.5842;Inherit;False;Property;_FrAddA;FrAddA;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;273;895.6487,341.9063;Inherit;False;Property;_FrAddMinusA;FrAddMinusA;17;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;895.7413,774.5107;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;319;863.5302,1039.18;Inherit;False;Property;_FrAddMinusC;FrAddMinusC;18;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;274;915.855,423.9315;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;299;892.6696,587.0015;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;310;875.535,692.4855;Inherit;False;Property;_FrAddMinusB;FrAddMinusB;19;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;337;1926.617,1645.665;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;166;-2010.745,-176.8604;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;312;1069.727,784.1635;Inherit;False;Property;_FrAddB;FrAddB;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;317;880.6648,933.6961;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;346;3244.741,-550.8053;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;276;912.7834,236.4223;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;338;1914.504,1753.227;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;316;1057.722,1130.858;Inherit;False;Property;_FrAddC;FrAddC;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;318;883.7365,1121.205;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;242;2161.103,1499.169;Inherit;True;Property;_CheckersA;CheckersA;10;0;Create;True;0;0;0;False;0;False;-1;None;8946dbf9c013f3e45867883da482858f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;347;3488.956,-566.0453;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;1;-1781.601,-155.6997;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-1993.601,-9.1996;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;301;1076.745,557.3865;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;245;2143.924,1836.338;Inherit;True;Property;_CheckersB;CheckersB;16;0;Create;True;0;0;0;False;0;False;-1;None;d56968f5711a6634da9b54167e83de76;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;243;2283.736,985.7416;Inherit;True;Property;_Albedo;Albedo;22;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;302;1077.941,671.3617;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;278;1098.055,320.7825;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;320;1064.74,904.0811;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;277;1096.859,206.8073;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;321;1065.936,1018.056;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;348;3687.056,-547.0272;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;279;1266.36,245.0081;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10000;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;303;1246.246,595.5873;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10000;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;323;1234.241,942.2819;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10000;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;313;1388.32,732.9462;Inherit;False;Property;_FrMulEndB;FrMulEndB;45;0;Create;True;0;0;0;False;0;False;-44;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;246;2734.706,996.0197;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;280;1263.864,375.9116;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10000;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;324;1231.745,1073.185;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10000;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-1574.201,-110.3994;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;304;1243.75,726.4908;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10000;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;285;2713.108,1750.959;Float;False;Property;_DissolveMul;DissolveMul;29;0;Create;True;0;0;0;False;0;False;0;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;1408.434,382.367;Inherit;False;Property;_FrMulEndA;FrMulEndA;44;0;Create;True;0;0;0;False;0;False;-44;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;322;1376.315,1079.641;Inherit;False;Property;_FrMulEndC;FrMulEndC;46;0;Create;True;0;0;0;False;0;False;-44;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;286;3416.874,1228.83;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;305;1386.683,596.3057;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;241;2755.22,1460.248;Float;False;Property;_DissolveAmount;Dissolve Amount;28;0;Create;True;0;0;0;False;0;False;0;-2.61;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;89;-1389.004,-112.5834;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;349;3680.657,-392.0432;Inherit;False;False;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;325;1374.678,943.0003;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;281;1406.797,245.7265;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;151;-935.9057,-1082.484;Inherit;False;1281.603;457.1994;Blend panning normals to fake noving ripples;7;19;23;24;21;22;17;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CosTime;355;3669.572,-8.319214;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;326;1523.351,1062.017;Inherit;False;Property;_FrColorC;FrColorC;51;0;Create;True;0;0;0;False;0;False;1,0.0518868,0.0518868,0;0,0.6132076,0.1886848,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;327;1526.098,929.3909;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;155;-1106.507,7.515848;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;251;3466.118,947.0459;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;306;1538.103,582.6963;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;354;3889.978,-448.3733;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;297;1555.47,364.7432;Inherit;False;Property;_FrColorA;FrColorA;49;0;Create;True;0;0;0;False;0;False;1,0.0518868,0.0518868,0;0.7372549,0,0.00707847,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;353;3714.385,-121.7943;Inherit;False;Property;_AnimDivBB1;AnimDivBB;20;0;Create;True;0;0;0;False;0;False;0.15;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;159;-863.7005,-467.5007;Inherit;False;1113.201;508.3005;Depths controls and colors;11;87;94;12;13;156;157;11;88;10;6;143;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;307;1535.356,715.3224;Inherit;False;Property;_FrColorB;FrColorB;50;0;Create;True;0;0;0;False;0;False;1,0.0518868,0.0518868,0;0.2772326,0,0.3207547,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;352;3715.975,-283.5973;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;351;3689.962,137.2717;Inherit;False;Property;_AnimDivCC1;AnimDivCC;24;0;Create;True;0;0;0;False;0;False;0.15;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;350;3884.365,-342.2242;Inherit;False;Constant;_Float7;Float 5;10;0;Create;True;0;0;0;False;0;False;0.19;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;153;-843.9032,402.718;Inherit;False;1083.102;484.2006;Foam controls and texture;9;116;105;106;115;111;110;112;113;114;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;193;1558.217,232.1171;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-885.9058,-1005.185;Inherit;False;0;17;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;333;1726.706,894.3487;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;331;1712.279,148.671;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;336;2395.312,665.2857;Inherit;False;Constant;_Float2;Float 2;46;0;Create;True;0;0;0;False;0;False;-0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;154;-922.7065,390.316;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;172;1151.126,-432.3254;Inherit;False;Property;_Frenc;Frenc;42;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.1886792,0.1886792,0.1886792,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;284;2361.116,457.74;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;360;4035.509,-71.44226;Inherit;False;Constant;_Float9;Float 7;10;0;Create;True;0;0;0;False;0;False;99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-557.3063,-795.3858;Float;False;Property;_NormalScale;Normal Scale;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;22;-613.2062,-1032.484;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.03,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;19;-610.9061,-919.9849;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;358;4045.365,-460.2242;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;359;3909.169,-221.4222;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;170;1091.408,-528.7559;Inherit;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;0;False;0;False;9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-813.7005,-128.1996;Float;False;Property;_WaterDepth;Water Depth;25;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-722.2024,526.6185;Float;False;Property;_FoamDepth;Foam Depth;38;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;356;3887.746,12.64368;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;357;4035.932,-173.5073;Inherit;False;Constant;_Float8;Float 6;10;0;Create;True;0;0;0;False;0;False;99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;332;1718.765,556.5571;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;158;-1075.608,-163.0834;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-269.2061,-1024.185;Inherit;True;Property;_Normal2;Normal2;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Instance;17;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;112;-531.4025,588.5187;Float;False;Property;_FoamFalloff;Foam Falloff;39;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;1308.104,-681.3461;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;361;4239.148,-409.1393;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;340;2105.554,688.6931;Inherit;False;Property;_DelRadugaFrencel;DelRadugaFrencel;53;0;Create;True;0;0;0;False;0;False;0.25;0.25;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;335;2553.842,459.5314;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-632.0056,-204.5827;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-636.2005,-79.20019;Float;False;Property;_WaterFalloff;Water Falloff;27;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;362;4314.586,-112.8483;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;334;1477.31,-412.9922;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;106;-793.9032,700.119;Inherit;False;0;105;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;17;-256.3054,-814.2847;Inherit;True;Property;_WaterNormal;Water Normal;0;0;Create;True;0;0;0;False;0;False;-1;None;f5453dca2ac649e4182c56a3966ad395;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-542.0016,452.718;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;150;467.1957,-1501.783;Inherit;False;985.6011;418.6005;Get screen color for refraction and disturbe it with normals;7;96;97;98;65;149;164;165;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;328;2011.814,950.8934;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;COLOR;1,1,1,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;87;-455.8059,-118.1832;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;116;-573.2014,720.3181;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.01,0.01;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;341;1618.361,-397.404;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;110;-357.2024,461.6185;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;-455.0999,-328.3;Float;False;Property;_ShalowColor;Shalow Color;23;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;364;4877.111,-307.5663;Inherit;False;Property;_FrencelNoiseMinus1;FrencelNoiseMinus;35;0;Create;True;0;0;0;False;0;False;-0.5;-0.61;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;171;1568.604,-680.473;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,1;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;365;4514.235,-163.7352;Inherit;True;Property;_FrencelNoiseB1;FrencelNoiseB;11;0;Create;True;0;0;0;False;0;False;-1;0bbd24355cfb3074392f4e25176bc9da;4f2de2830901651419eb727f6b7e6066;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;363;4457.251,-455.9232;Inherit;True;Property;_FrencelNoiseA1;FrencelNoiseA;5;0;Create;True;0;0;0;False;0;False;-1;0bbd24355cfb3074392f4e25176bc9da;a61151a08d8413b4585e30c14c713e3d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;24;170.697,-879.6849;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;308;2096.179,448.1942;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;COLOR;1,1,1,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;12;-697.5002,-417.5007;Float;False;Property;_DeepColor;Deep Color;15;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;2097.134,187.5213;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;COLOR;1,1,1,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;94;-249.5044,-96.98394;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;149;487.4943,-1188.882;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;97;710.096,-1203.183;Float;False;Property;_Distortion;Distortion;33;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;369;4820.349,61.79675;Inherit;False;Property;_FrencelNoiseMult1;FrencelNoiseMult;36;0;Create;True;0;0;0;False;0;False;0;9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;157;-149.1077,-261.9834;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;366;5013.775,-167.2063;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;113;-136.0011,509.618;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;164;511.3026,-1442.425;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;156;-151.0076,-354.5834;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;105;-304.4021,674.9185;Inherit;True;Property;_Foam;Foam;34;0;Create;True;0;0;0;False;0;False;-1;None;2861704728ea79f479cabb70dd2fe923;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;182;1775.142,-543.8549;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;197;1903.744,-430.5677;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;888.1974,-1279.783;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;108;58.99682,146.0182;Float;False;Constant;_Color0;Color 0;-1;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;13;60.50008,-220.6998;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;367;5101.4,27.73169;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;80.19891,604.0181;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;165;814.6503,-1385.291;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;282;2268.798,85.68397;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;343;2240.223,-120.5704;Inherit;False;Constant;_Float3;Float 3;48;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;372;2163.51,-313.3566;Inherit;False;Constant;_Float6;Float 6;54;0;Create;True;0;0;0;False;0;False;1.66;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;198;2062.189,-408.5009;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;117;323.797,77.91843;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;370;2941.181,-97.28812;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;1041.296,-1346.683;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;143;95.69542,-321.0839;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;181;1035.544,-102.7423;Inherit;True;Property;_AddCol;AddCol;47;0;Create;True;0;0;0;False;0;False;-1;None;9951e4bcc83d5e540bbfc7fdc0879b26;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;131;756.1969,-467.1806;Float;False;Property;_FoamSpecular;Foam Specular;40;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;65;1232.797,-1350.483;Float;False;Global;_WaterGrab;WaterGrab;-1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;342;2318.089,-339.4958;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;161;660.4934,-750.6837;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;230;2117.89,-200.868;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;104;753.9969,-565.4819;Float;False;Property;_WaterSpecular;Water Specular;30;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;162;1312.293,-894.3823;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;371;2219.101,-451.0873;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;249;2782.851,1159.273;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;248;2808.063,1327.394;Inherit;False;Property;_DisplScal;DisplScal;26;0;Create;True;0;0;0;False;0;False;0.1;0.009;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;1764.69,2171.446;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;267;1891.01,1868.487;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;189;1720.491,-172.2103;Inherit;False;Constant;_Float1;Float 1;19;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;130;955.7971,-465.8806;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;983.613,-737.5303;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;187;1804.012,-97.3995;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;191;1932.496,-129.6656;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;254;1263.48,1434.308;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;132;914.3978,-199.48;Float;False;Property;_FoamSmoothness;Foam Smoothness;41;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;1636.845,-94.29959;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;920.1959,-279.1855;Float;False;Property;_WaterSmoothness;Water Smoothness;31;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;264;1713.933,2012.894;Inherit;False;Constant;_Float4;Float 4;10;0;Create;True;0;0;0;False;0;False;99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;250;3044.498,1132.773;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;175;921.613,-615.5303;Inherit;False;Property;_FrMulOldEmis;FrMulOldEmis;43;0;Create;True;0;0;0;False;0;False;44;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;244;3014.708,1522.247;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;1621.789,1521.111;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;296;1861.62,1372.391;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector4Node;292;1282.941,2289.713;Inherit;False;Property;_VectorDirection;VectorDirection;48;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.1,2,1,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;257;1466.402,1532.962;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;255;1257.081,1589.292;Inherit;False;False;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;133;1160.541,-232.9454;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;295;1626.22,1374.866;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PosVertexDataNode;252;768.4036,1430.53;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;93;1559.196,-1006.285;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;368;4042.365,-341.2242;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;288;2576.915,-485.0114;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FloorOpNode;174;1156.613,-715.5303;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;268;1924.541,1528.464;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;253;1065.38,1415.29;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;294;1617.117,2105.799;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCRemapNode;247;3295.525,1480.032;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;167;652.6469,-723.6737;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;1460.789,1639.111;Inherit;False;Property;_DrawMaskSize;DrawMaskSize;21;0;Create;True;0;0;0;False;0;False;1;0.16;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;183;1347.665,37.38583;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;283;2526.695,-337.3235;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;265;1798.356,1624.829;Inherit;False;Constant;_Float5;Float 5;10;0;Create;True;0;0;0;False;0;False;99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2753.51,-641.2183;Half;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;ASESampleShaders/PeopleSegmentedShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;2;5;False;-1;10;False;-1;4;1;False;-1;1;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;266;0;260;1
WireConnection;266;1;261;0
WireConnection;262;0;256;1
WireConnection;262;1;259;0
WireConnection;300;0;298;0
WireConnection;300;1;311;0
WireConnection;274;0;270;0
WireConnection;274;1;271;0
WireConnection;299;0;298;0
WireConnection;299;1;309;0
WireConnection;337;0;339;0
WireConnection;337;1;262;0
WireConnection;317;0;314;0
WireConnection;317;1;329;0
WireConnection;276;0;270;0
WireConnection;276;1;272;0
WireConnection;338;0;339;0
WireConnection;338;1;266;0
WireConnection;318;0;314;0
WireConnection;318;1;315;0
WireConnection;242;1;337;0
WireConnection;347;0;346;0
WireConnection;1;0;166;0
WireConnection;301;0;299;0
WireConnection;301;1;310;0
WireConnection;245;1;338;0
WireConnection;302;0;300;0
WireConnection;302;1;312;0
WireConnection;278;0;274;0
WireConnection;278;1;275;0
WireConnection;320;0;317;0
WireConnection;320;1;319;0
WireConnection;277;0;276;0
WireConnection;277;1;273;0
WireConnection;321;0;318;0
WireConnection;321;1;316;0
WireConnection;348;0;347;0
WireConnection;279;0;277;0
WireConnection;303;0;301;0
WireConnection;323;0;320;0
WireConnection;246;0;243;0
WireConnection;246;1;242;0
WireConnection;246;2;245;0
WireConnection;280;0;278;0
WireConnection;324;0;321;0
WireConnection;3;0;1;0
WireConnection;3;1;2;4
WireConnection;304;0;302;0
WireConnection;286;0;246;0
WireConnection;286;1;285;0
WireConnection;305;0;303;0
WireConnection;305;1;304;0
WireConnection;305;2;313;0
WireConnection;89;0;3;0
WireConnection;349;0;348;0
WireConnection;325;0;323;0
WireConnection;325;1;324;0
WireConnection;325;2;322;0
WireConnection;281;0;279;0
WireConnection;281;1;280;0
WireConnection;281;2;185;0
WireConnection;327;0;325;0
WireConnection;327;1;325;0
WireConnection;327;2;325;0
WireConnection;155;0;89;0
WireConnection;251;0;241;0
WireConnection;251;1;286;0
WireConnection;306;0;305;0
WireConnection;306;1;305;0
WireConnection;306;2;305;0
WireConnection;354;0;348;0
WireConnection;354;1;349;0
WireConnection;193;0;281;0
WireConnection;193;1;281;0
WireConnection;193;2;281;0
WireConnection;333;0;327;0
WireConnection;333;1;326;0
WireConnection;331;0;193;0
WireConnection;331;1;297;0
WireConnection;154;0;155;0
WireConnection;284;0;251;0
WireConnection;22;0;21;0
WireConnection;19;0;21;0
WireConnection;358;0;354;0
WireConnection;358;1;350;0
WireConnection;359;0;352;1
WireConnection;359;1;353;0
WireConnection;356;0;355;1
WireConnection;356;1;351;0
WireConnection;332;0;306;0
WireConnection;332;1;307;0
WireConnection;158;0;89;0
WireConnection;23;1;22;0
WireConnection;23;5;48;0
WireConnection;169;0;172;0
WireConnection;169;1;281;0
WireConnection;169;2;170;0
WireConnection;361;0;358;0
WireConnection;361;1;357;0
WireConnection;361;2;359;0
WireConnection;335;0;284;0
WireConnection;335;1;336;0
WireConnection;88;0;158;0
WireConnection;88;1;6;0
WireConnection;362;0;358;0
WireConnection;362;1;360;0
WireConnection;362;2;356;0
WireConnection;334;0;331;0
WireConnection;334;1;332;0
WireConnection;334;2;333;0
WireConnection;17;1;19;0
WireConnection;115;0;154;0
WireConnection;115;1;111;0
WireConnection;328;0;327;0
WireConnection;328;1;326;0
WireConnection;328;2;335;0
WireConnection;328;3;340;0
WireConnection;87;0;88;0
WireConnection;87;1;10;0
WireConnection;116;0;106;0
WireConnection;341;0;334;0
WireConnection;341;1;340;0
WireConnection;110;0;115;0
WireConnection;110;1;112;0
WireConnection;171;0;169;0
WireConnection;365;1;362;0
WireConnection;363;1;361;0
WireConnection;24;0;23;0
WireConnection;24;1;17;0
WireConnection;308;0;306;0
WireConnection;308;1;307;0
WireConnection;308;2;335;0
WireConnection;308;3;340;0
WireConnection;186;0;193;0
WireConnection;186;1;297;0
WireConnection;186;2;335;0
WireConnection;186;3;340;0
WireConnection;94;0;87;0
WireConnection;149;0;24;0
WireConnection;157;0;11;0
WireConnection;366;0;364;0
WireConnection;366;1;363;1
WireConnection;366;2;365;1
WireConnection;113;0;110;0
WireConnection;156;0;12;0
WireConnection;105;1;116;0
WireConnection;182;0;171;0
WireConnection;182;1;186;0
WireConnection;182;2;308;0
WireConnection;182;3;328;0
WireConnection;182;4;341;0
WireConnection;197;0;182;0
WireConnection;98;0;149;0
WireConnection;98;1;97;0
WireConnection;13;0;156;0
WireConnection;13;1;157;0
WireConnection;13;2;94;0
WireConnection;367;0;366;0
WireConnection;367;1;369;0
WireConnection;114;0;113;0
WireConnection;114;1;105;1
WireConnection;165;0;164;0
WireConnection;282;0;251;0
WireConnection;198;0;197;0
WireConnection;198;1;197;1
WireConnection;198;2;197;2
WireConnection;117;0;13;0
WireConnection;117;1;108;0
WireConnection;117;2;114;0
WireConnection;370;0;367;0
WireConnection;96;0;165;0
WireConnection;96;1;98;0
WireConnection;143;0;94;0
WireConnection;65;0;96;0
WireConnection;342;0;198;0
WireConnection;342;1;343;0
WireConnection;342;2;370;0
WireConnection;161;0;117;0
WireConnection;230;0;181;0
WireConnection;230;1;282;0
WireConnection;162;0;143;0
WireConnection;371;0;181;0
WireConnection;371;1;372;0
WireConnection;289;0;294;0
WireConnection;289;1;292;0
WireConnection;267;0;263;0
WireConnection;267;1;289;0
WireConnection;267;2;264;0
WireConnection;130;0;104;0
WireConnection;130;1;131;0
WireConnection;130;2;114;0
WireConnection;176;0;167;0
WireConnection;176;1;175;0
WireConnection;187;0;184;0
WireConnection;187;1;189;0
WireConnection;191;0;187;0
WireConnection;254;0;253;0
WireConnection;184;0;183;0
WireConnection;250;0;249;0
WireConnection;250;1;246;0
WireConnection;250;2;248;0
WireConnection;244;0;241;0
WireConnection;263;0;257;0
WireConnection;263;1;258;0
WireConnection;296;0;295;0
WireConnection;296;1;292;0
WireConnection;257;0;254;0
WireConnection;257;1;255;0
WireConnection;255;0;254;0
WireConnection;133;0;26;0
WireConnection;133;1;132;0
WireConnection;133;2;114;0
WireConnection;295;0;262;0
WireConnection;295;1;262;0
WireConnection;295;2;262;0
WireConnection;295;3;262;0
WireConnection;93;0;161;0
WireConnection;93;1;65;0
WireConnection;93;2;162;0
WireConnection;368;0;354;0
WireConnection;368;1;350;0
WireConnection;288;0;371;0
WireConnection;288;1;182;0
WireConnection;174;0;176;0
WireConnection;268;0;263;0
WireConnection;268;1;296;0
WireConnection;268;2;265;0
WireConnection;253;0;252;0
WireConnection;294;0;266;0
WireConnection;294;1;266;0
WireConnection;294;2;266;0
WireConnection;294;3;266;0
WireConnection;247;0;244;0
WireConnection;283;0;342;0
WireConnection;283;1;230;0
WireConnection;0;0;93;0
WireConnection;0;1;24;0
WireConnection;0;2;288;0
WireConnection;0;3;130;0
WireConnection;0;9;283;0
WireConnection;0;10;283;0
WireConnection;0;11;250;0
ASEEND*/
//CHKSM=1C2525A5E42C4F7A82C9F1BB06268723E4BDA457