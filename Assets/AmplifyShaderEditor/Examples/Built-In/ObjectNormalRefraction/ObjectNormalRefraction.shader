// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASESampleShaders/ObjectNormalRefraction"
{
	Properties
	{
		[Header(Refraction)]
		_ChromaticAberration("Chromatic Aberration", Range( 0 , 0.3)) = 0.1
		_Color1("Color", Color) = (0,0,0,0)
		_OpacityTex1("OpacityTex", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_OpacityNoiseTex1("OpacityNoiseTex", 2D) = "white" {}
		_NormalScale("Normal Scale", Range( 0 , 1)) = 0.1
		_Albedo1("Albedo", 2D) = "white" {}
		_CubeMap("Cube Map", CUBE) = "white" {}
		_Opacity1("Opacity", Range( 0 , 2)) = 0.5
		_IndexofRefraction("Index of Refraction", Range( -3 , 4)) = 1
		_OpacityNoiseMult1("OpacityNoiseMult", Range( 0 , 2)) = 0.5
		_ShieldAnimSpeedA1("Shield Anim SpeedA", Range( -10 , 10)) = 3
		_ShieldAnimSpeedB1("Shield Anim SpeedB", Range( -10 , 10)) = 3
		_NoAnimMainTex1("NoAnimMainTex", Float) = 0
		_MinusOpacity1("MinusOpacity", Float) = -0.112
		_Refl("Refl", Float) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile _ALPHAPREMULTIPLY_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldRefl;
			INTERNAL_DATA
			float4 screenPos;
			float3 worldPos;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _NormalScale;
		uniform samplerCUBE _CubeMap;
		uniform float _Refl;
		uniform float4 _Color1;
		uniform sampler2D _Albedo1;
		uniform float _ShieldAnimSpeedA1;
		uniform float _ShieldAnimSpeedB1;
		uniform float _NoAnimMainTex1;
		uniform sampler2D _OpacityNoiseTex1;
		uniform float _OpacityNoiseMult1;
		uniform float _MinusOpacity1;
		uniform sampler2D _OpacityTex1;
		uniform float4 _OpacityTex1_ST;
		uniform float _Opacity1;
		uniform sampler2D _GrabTexture;
		uniform float _ChromaticAberration;
		uniform float _IndexofRefraction;

		inline float4 Refraction( Input i, SurfaceOutputStandard o, float indexOfRefraction, float chomaticAberration ) {
			float3 worldNormal = o.Normal;
			float4 screenPos = i.screenPos;
			#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
			#else
				float scale = 1.0;
			#endif
			float halfPosW = screenPos.w * 0.5;
			screenPos.y = ( screenPos.y - halfPosW ) * _ProjectionParams.x * scale + halfPosW;
			#if SHADER_API_D3D9 || SHADER_API_D3D11
				screenPos.w += 0.00000000001;
			#endif
			float2 projScreenPos = ( screenPos / screenPos.w ).xy;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 refractionOffset = ( indexOfRefraction - 1.0 ) * mul( UNITY_MATRIX_V, float4( worldNormal, 0.0 ) ) * ( 1.0 - dot( worldNormal, worldViewDir ) );
			float2 cameraRefraction = float2( refractionOffset.x, refractionOffset.y );
			float4 redAlpha = tex2D( _GrabTexture, ( projScreenPos + cameraRefraction ) );
			float green = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 - chomaticAberration ) ) ) ).g;
			float blue = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 + chomaticAberration ) ) ) ).b;
			return float4( redAlpha.r, green, blue, redAlpha.a );
		}

		void RefractionF( Input i, SurfaceOutputStandard o, inout half4 color )
		{
			#ifdef UNITY_PASS_FORWARDBASE
			color.rgb = color.rgb + Refraction( i, o, _IndexofRefraction, _ChromaticAberration ) * ( 1 - color.a );
			color.a = 1;
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 tex2DNode54 = UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap ), _NormalScale );
			o.Normal = tex2DNode54;
			float4 texCUBENode45 = texCUBE( _CubeMap, WorldReflectionVector( i , tex2DNode54 ) );
			o.Albedo = texCUBENode45.rgb;
			float4 appendResult63 = (float4(( _Time.x * _ShieldAnimSpeedA1 ) , ( _Time.x * _ShieldAnimSpeedB1 ) , 0.0 , 0.0));
			float2 uv_TexCoord69 = i.uv_texcoord + ( appendResult63 * _NoAnimMainTex1 ).xy;
			float4 temp_output_77_0 = ( _Color1 * tex2D( _Albedo1, uv_TexCoord69 ) * 4.0 );
			float2 uv_TexCoord72 = i.uv_texcoord + appendResult63.xy;
			float4 tex2DNode79 = tex2D( _OpacityNoiseTex1, uv_TexCoord72 );
			float4 clampResult93 = clamp( ( ( texCUBENode45 * _Refl ) + ( temp_output_77_0 + ( tex2DNode79 * _OpacityNoiseMult1 ) + _MinusOpacity1 ) ) , float4(-0.1,-0.1,-0.1,-0.1) , float4(1000,1000,1000,1000) );
			o.Emission = clampResult93.rgb;
			float2 uv_OpacityTex1 = i.uv_texcoord * _OpacityTex1_ST.xy + _OpacityTex1_ST.zw;
			float4 temp_output_68_0 = ( tex2D( _OpacityTex1, uv_OpacityTex1 ) * _Opacity1 );
			float4 clampResult94 = clamp( ( ( temp_output_77_0 * temp_output_68_0 ) + ( tex2DNode79 * 0.0 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			o.Alpha = clampResult94.r;
			o.Normal = o.Normal + 0.00001 * i.screenPos * i.worldPos;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha finalcolor:RefractionF fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldRefl = -worldViewDir;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
457;290;1571;873;2000.517;-708.8527;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;56;-2452.695,482.9885;Inherit;False;830.728;358.1541;Comment;3;61;60;58;Animation Speed;1,1,1,1;0;0
Node;AmplifyShaderEditor.TimeNode;58;-2329.103,532.9875;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;59;-2511.248,1080.003;Float;False;Property;_ShieldAnimSpeedB1;Shield Anim SpeedB;15;0;Create;True;0;0;0;False;0;False;3;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-2402.695,726.1425;Float;False;Property;_ShieldAnimSpeedA1;Shield Anim SpeedA;14;0;Create;True;0;0;0;False;0;False;3;3.3;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-2086.567,656.4014;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-2195.12,1010.262;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;57;-1348.19,-90.73362;Inherit;False;837.0001;689.9695;Comment;2;42;55;Textures;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;63;-1918.124,935.1685;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1958.327,1086.05;Inherit;False;Property;_NoAnimMainTex1;NoAnimMainTex;16;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-926.161,-77.13029;Float;False;Property;_NormalScale;Normal Scale;6;0;Create;True;0;0;0;False;0;False;0.1;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1730.002,963.3655;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-1549.989,812.3984;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;54;-646.7961,72.9934;Inherit;True;Property;_NormalMap;Normal Map;4;0;Create;True;0;0;0;False;0;False;-1;None;066f29fd0fc3d0341b96857dcf2cede3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;72;-2074.258,1306.483;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;65;-967.4004,1197.854;Float;False;Property;_Opacity1;Opacity;11;0;Create;True;0;0;0;False;0;False;0.5;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldReflectionVector;46;-268.58,-82.80111;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;79;-1829.323,1290.33;Inherit;True;Property;_OpacityNoiseTex1;OpacityNoiseTex;5;0;Create;True;0;0;0;False;0;False;-1;None;459d8268ad2f9454c81abaa3bc6f3408;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;76;-1524.851,1381.877;Float;False;Property;_OpacityNoiseMult1;OpacityNoiseMult;13;0;Create;True;0;0;0;False;0;False;0.5;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;75;-1073.37,697.3728;Float;False;Property;_Color1;Color;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.1792453,0.1792453,0.1792453,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;71;-1383.219,580.2927;Inherit;True;Property;_Albedo1;Albedo;7;0;Create;True;0;0;0;False;0;False;-1;None;54d7aec97cb916047b0ef2fe9e52a349;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;73;-704.449,867.1989;Inherit;False;Constant;_Float1;Float 0;12;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;66;-1096.488,891.1111;Inherit;True;Property;_OpacityTex1;OpacityTex;3;0;Create;True;0;0;0;False;0;False;-1;None;0d8a26cec82234c4f843595e1ae00caa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-715.7527,965.4014;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;45;-64.07985,-181.8011;Inherit;True;Property;_CubeMap;Cube Map;8;0;Create;True;0;0;0;False;0;False;-1;56a68e301a0ff55469ae441c0112d256;382472a1d831371459a27c9124228297;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;80;-280.5204,1433.443;Inherit;False;Constant;_adddd1;adddd;10;0;Create;True;0;0;0;False;0;False;0;-0.83;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-1254.127,1154.471;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;92;133.2153,43.17281;Inherit;False;Property;_Refl;Refl;19;0;Create;True;0;0;0;False;0;False;0.1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-220.7261,937.1915;Inherit;False;Property;_MinusOpacity1;MinusOpacity;17;0;Create;True;0;0;0;False;0;False;-0.112;-0.76;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-682.7788,683.7084;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;59.21122,875.3895;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;278.2153,-40.82719;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-216.0358,1104.625;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-60.8204,1377.642;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector4Node;95;315.5332,335.7913;Inherit;False;Constant;_Vector0;Vector 0;19;0;Create;True;0;0;0;False;0;False;-0.1,-0.1,-0.1,-0.1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;89;352.4775,136.0964;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;157.7907,1116.072;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector4Node;96;475.5332,366.7913;Inherit;False;Constant;_Vector1;Vector 0;19;0;Create;True;0;0;0;False;0;False;1000,1000,1000,1000;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;78;-474.325,1182.446;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1267.911,22.54307;Float;False;Property;_Opacity;Opacity;10;0;Create;True;0;0;0;False;0;False;0;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-94.70272,1046.212;Inherit;False;Property;_Blesk1;Blesk;18;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;82.89262,988.0955;Inherit;False;Constant;_Float2;Float 1;12;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;94;556.9493,579.9503;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;85;-120.3739,614.2145;Inherit;True;Property;_Normal1;Normal;9;0;Create;True;0;0;0;False;0;False;-1;None;302951faffe230848aa0d3df7bb70faa;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;69.73558,201.2575;Float;False;Property;_IndexofRefraction;Index of Refraction;12;0;Create;True;0;0;0;False;0;False;1;1.1;-3;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;93;514.4954,139.8596;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;749.3,32.80001;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ASESampleShaders/ObjectNormalRefraction;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;0;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.2;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;52;304.7198,-183.0011;Inherit;False;293.1999;207.6;Multiplier to make it POP;0;;1,1,1,1;0;0
WireConnection;61;0;58;1
WireConnection;61;1;60;0
WireConnection;62;0;58;1
WireConnection;62;1;59;0
WireConnection;63;0;61;0
WireConnection;63;1;62;0
WireConnection;67;0;63;0
WireConnection;67;1;64;0
WireConnection;69;1;67;0
WireConnection;54;5;55;0
WireConnection;72;1;63;0
WireConnection;46;0;54;0
WireConnection;79;1;72;0
WireConnection;71;1;69;0
WireConnection;68;0;66;0
WireConnection;68;1;65;0
WireConnection;45;1;46;0
WireConnection;82;0;79;0
WireConnection;82;1;76;0
WireConnection;77;0;75;0
WireConnection;77;1;71;0
WireConnection;77;2;73;0
WireConnection;84;0;77;0
WireConnection;84;1;82;0
WireConnection;84;2;70;0
WireConnection;91;0;45;0
WireConnection;91;1;92;0
WireConnection;83;0;77;0
WireConnection;83;1;68;0
WireConnection;81;0;79;0
WireConnection;81;1;80;0
WireConnection;89;0;91;0
WireConnection;89;1;84;0
WireConnection;88;0;83;0
WireConnection;88;1;81;0
WireConnection;78;0;68;0
WireConnection;94;0;88;0
WireConnection;93;0;89;0
WireConnection;93;1;95;0
WireConnection;93;2;96;0
WireConnection;0;0;45;0
WireConnection;0;1;54;0
WireConnection;0;2;93;0
WireConnection;0;8;41;0
WireConnection;0;9;94;0
ASEEND*/
//CHKSM=9C1AAE39F1CC9415D0626AD23A6E546D64F28CCB