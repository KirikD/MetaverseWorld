// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SineVFX/ForceFieldAndShieldEffects/ForceFieldDistortionMultipleLWRP"
{
    Properties
    {
		_MaskFresnelExp("Mask Fresnel Exp", Range( 0.2 , 8)) = 4
		_MaskDepthFadeDistance("Mask Depth Fade Distance", Float) = 6
		_MaskDepthFadeExp("Mask Depth Fade Exp", Range( 0.2 , 10)) = 4
		[Toggle(_MASKSOFTBORDERS_ON)] _MaskSoftBorders("Mask Soft Borders", Float) = 0
		_MaskSoftBordersMultiply("Mask Soft Borders Multiply", Float) = 1.01
		_MaskSoftBordersExp("Mask Soft Borders Exp", Float) = 20
		_NormalVertexOffset("Normal Vertex Offset", Float) = 0
		[Toggle(_LOCALNOISEPOSITION_ON)] _LocalNoisePosition("Local Noise Position", Float) = 0
		_NoiseMaskPower("Noise Mask Power", Range( 0 , 10)) = 1
		_Noise01("Noise 01", 2D) = "white" {}
		_Noise01Tiling("Noise 01 Tiling", Float) = 1
		_Noise01ScrollSpeed("Noise 01 Scroll Speed", Float) = 0.25
		[Toggle(_NOISE02ENABLED_ON)] _Noise02Enabled("Noise 02 Enabled", Float) = 0
		_Noise02("Noise 02", 2D) = "white" {}
		_Noise02Tiling("Noise 02 Tiling", Float) = 1
		_Noise02ScrollSpeed("Noise 02 Scroll Speed", Float) = 0.25
		[Toggle(_NOISEDISTORTIONENABLED_ON)] _NoiseDistortionEnabled("Noise Distortion Enabled", Float) = 1
		_NoiseDistortion("Noise Distortion", 2D) = "white" {}
		_NoiseDistortionPower("Noise Distortion Power", Range( 0 , 2)) = 0.5
		_NoiseDistortionTiling("Noise Distortion Tiling", Float) = 0.5
		_ScreenDistortionPower("Screen Distortion Power", Range( 0 , 0.2)) = 0.025
		_MaskAppearLocalYRemap("Mask Appear Local Y Remap", Float) = 0.5
		_MaskAppearLocalYAdd("Mask Appear Local Y Add", Float) = 0
		[Toggle(_MASKAPPEARINVERT_ON)] _MaskAppearInvert("Mask Appear Invert", Float) = 0
		_MaskAppearProgress("Mask Appear Progress", Range( -2 , 2)) = 0
		_MaskAppearNoise("Mask Appear Noise", 2D) = "white" {}
		_MaskAppearRamp("Mask Appear Ramp", 2D) = "white" {}
		[Toggle(_MASKAPPEARNOISETRIPLANAR_ON)] _MaskAppearNoiseTriplanar("Mask Appear Noise Triplanar", Float) = 0
		_MaskAppearNoiseTriplanarTiling("Mask Appear Noise Triplanar Tiling", Float) = 0.2
		_InterceptionPower("Interception Power", Float) = 1
		_InterceptionOffset("Interception Offset", Float) = 1
		_ThresholdForInterception("Threshold For Interception", Float) = 1.001
		_ThresholdForSpheres("Threshold For Spheres", Float) = 0.99
		[Toggle(_VISUALIZEMASKDEBUG_ON)] _VisualizeMaskDebug("Visualize Mask Debug", Float) = 0

    }

    SubShader
    {
		

        Tags { "RenderPipeline"="LightweightPipeline" "RenderType"="Transparent" "Queue"="Transparent" }
        Cull Back
		HLSLINCLUDE
		#pragma target 3.0
		ENDHLSL

		
        Pass
        {
            Tags { "LightMode"="LightweightForward" }
            Name "Base"

            Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

            HLSLPROGRAM
            #define ASE_SRP_VERSION 60902
            #define REQUIRE_OPAQUE_TEXTURE 1
            #define ASE_TEXTURE_PARAMS(textureName) textureName
            
            #define REQUIRE_DEPTH_TEXTURE 1

            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x

            // -------------------------------------
            // Lightweight Pipeline keywords
            #pragma shader_feature _SAMPLE_GI

            // -------------------------------------
            // Unity defined keywords
			#ifdef ASE_FOG
            #pragma multi_compile_fog
			#endif
            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            
            #pragma vertex vert
            #pragma fragment frag


            // Lighting include is needed because of GI
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/Shaders/UnlitInput.hlsl"

            #pragma shader_feature _VISUALIZEMASKDEBUG_ON
            #pragma shader_feature _LOCALNOISEPOSITION_ON
            #pragma shader_feature _NOISEDISTORTIONENABLED_ON
            #pragma shader_feature _NOISE02ENABLED_ON
            #pragma shader_feature _MASKSOFTBORDERS_ON
            #pragma shader_feature _MASKAPPEARINVERT_ON
            #pragma shader_feature _MASKAPPEARNOISETRIPLANAR_ON


			sampler2D _Noise01;
			sampler2D _NoiseDistortion;
			sampler2D _Noise02;
			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _MaskAppearRamp;
			sampler2D _MaskAppearNoise;
			float4 _FFSpherePositions[20];
			float _FFSphereSizes[20];
			float _FFSphereCount;
			CBUFFER_START( UnityPerMaterial )
			float _NormalVertexOffset;
			float _Noise01Tiling;
			float _Noise01ScrollSpeed;
			float _NoiseDistortionTiling;
			float _NoiseDistortionPower;
			float _Noise02Tiling;
			float _Noise02ScrollSpeed;
			float _NoiseMaskPower;
			float _ScreenDistortionPower;
			float _MaskFresnelExp;
			float _MaskDepthFadeDistance;
			float _MaskDepthFadeExp;
			float _MaskSoftBordersMultiply;
			float _MaskSoftBordersExp;
			float _MaskAppearLocalYRemap;
			float _MaskAppearLocalYAdd;
			float _MaskAppearProgress;
			float4 _MaskAppearNoise_ST;
			float _MaskAppearNoiseTriplanarTiling;
			float _InterceptionOffset;
			float _ThresholdForInterception;
			float _ThresholdForSpheres;
			float _InterceptionPower;
			CBUFFER_END


            struct GraphVertexInput
            {
                float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct GraphVertexOutput
            {
                float4 position : POSITION;
				#ifdef ASE_FOG
				float fogCoord : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

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
			
			inline float4 TriplanarSamplingSF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
				yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
				zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
				return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
			}
			
			float2 MyCustomExpression172( float NegatedOffsetCE , float4 FFSpherePositionsCE , float FFSphereSizesCE , float3 WorldPosCE , int FFSphereCountCE , float IOCE , float TFICE )
			{
				float MyResult = 0;
				float DistanceMask45;
				float secondResult = 0;
				float secondResult2 = 0;
				for (int i = 0; i < FFSphereCountCE; i++){
				float myTempAdd = -((_FFSphereSizes[i] - 2) / 2);
				DistanceMask45 = distance( WorldPosCE , _FFSpherePositions[i] );
				float correctSize = (_FFSphereSizes[i] / 2) - NegatedOffsetCE;
				float ifA = (correctSize + IOCE - DistanceMask45);
				float ifB = (correctSize + IOCE) - (TFICE * correctSize);
				if (i == 0)
				{
				if (ifA > ifB)
				{
				secondResult = 0;
				}
				else
				{
				secondResult = ifA;
				}
				}
				else
				{
				if (ifA > ifB)
				{
				secondResult2 = 0;
				}
				else
				{
				secondResult2 = ifA;
				}
				secondResult = max(secondResult, secondResult2);
				}
				if (i == 0)
				{
				MyResult = (DistanceMask45 + myTempAdd + NegatedOffsetCE);
				}
				else
				{
				MyResult = min((DistanceMask45 + myTempAdd + NegatedOffsetCE), MyResult);
				}
				}
				float2 testt = float2(MyResult, secondResult);
				return testt;
			}
			

            GraphVertexOutput vert (GraphVertexInput v)
            {
                GraphVertexOutput o = (GraphVertexOutput)0;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord1 = screenPos;
				o.ase_texcoord2.xyz = ase_worldNormal;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				o.ase_texcoord3.xyz = ase_worldPos;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord4.xyz = ase_worldTangent;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord5.xyz = ase_worldBitangent;
				
				o.ase_texcoord6 = v.vertex;
				o.ase_texcoord7.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				o.ase_texcoord5.w = 0;
				o.ase_texcoord7.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = v.vertex.xyz;
				#else
				float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( ase_worldNormal * ( _NormalVertexOffset / ase_objectScale.x ) );
				#ifdef ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue; 
				#else
				v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal =  v.ase_normal ;
                o.position = TransformObjectToHClip(v.vertex.xyz);
				#ifdef ASE_FOG
				o.fogCoord = ComputeFogFactor( o.position.z );
				#endif
                return o;
            }

            half4 frag (GraphVertexOutput IN , half ase_vface : VFACE) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
				float4 screenPos = IN.ase_texcoord1;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float3 ase_worldNormal = IN.ase_texcoord2.xyz;
				float3 temp_output_57_0 = abs( ase_worldNormal );
				float3 temp_output_60_0 = ( temp_output_57_0 * temp_output_57_0 );
				float3 ase_worldPos = IN.ase_texcoord3.xyz;
				float4 transform130 = mul(GetObjectToWorldMatrix(),float4(0,0,0,1));
				float3 appendResult132 = (float3(transform130.x , transform130.y , transform130.z));
				#ifdef _LOCALNOISEPOSITION_ON
				float3 staticSwitch134 = ( ase_worldPos - appendResult132 );
				#else
				float3 staticSwitch134 = ase_worldPos;
				#endif
				float3 FinalWorldPosition135 = staticSwitch134;
				float4 temp_cast_1 = (0.0).xxxx;
				float4 triplanar34 = TriplanarSamplingSF( _NoiseDistortion, ase_worldPos, ase_worldNormal, 1.0, _NoiseDistortionTiling, 1.0, 0 );
				#ifdef _NOISEDISTORTIONENABLED_ON
				float4 staticSwitch42 = ( triplanar34 * _NoiseDistortionPower );
				#else
				float4 staticSwitch42 = temp_cast_1;
				#endif
				float4 break58 = ( float4( ( FinalWorldPosition135 * _Noise01Tiling ) , 0.0 ) + ( _Time.y * _Noise01ScrollSpeed ) + staticSwitch42 );
				float2 appendResult64 = (float2(break58.y , break58.z));
				float2 appendResult65 = (float2(break58.z , break58.x));
				float2 appendResult67 = (float2(break58.x , break58.y));
				float3 weightedBlendVar73 = temp_output_60_0;
				float weightedBlend73 = ( weightedBlendVar73.x*UnpackNormalScale( tex2D( _Noise01, appendResult64 ), 1.0f ).r + weightedBlendVar73.y*UnpackNormalScale( tex2D( _Noise01, appendResult65 ), 1.0f ).r + weightedBlendVar73.z*UnpackNormalScale( tex2D( _Noise01, appendResult67 ), 1.0f ).r );
				float4 break51 = ( float4( ( FinalWorldPosition135 * _Noise02Tiling ) , 0.0 ) + ( _Time.y * _Noise02ScrollSpeed ) + staticSwitch42 );
				float2 appendResult59 = (float2(break51.y , break51.z));
				float2 appendResult56 = (float2(break51.z , break51.x));
				float2 appendResult54 = (float2(break51.x , break51.y));
				float3 weightedBlendVar69 = temp_output_60_0;
				float weightedBlend69 = ( weightedBlendVar69.x*UnpackNormalScale( tex2D( _Noise02, appendResult59 ), 1.0f ).r + weightedBlendVar69.y*UnpackNormalScale( tex2D( _Noise02, appendResult56 ), 1.0f ).r + weightedBlendVar69.z*UnpackNormalScale( tex2D( _Noise02, appendResult54 ), 1.0f ).r );
				#ifdef _NOISE02ENABLED_ON
				float staticSwitch75 = weightedBlend69;
				#else
				float staticSwitch75 = 1.0;
				#endif
				float ResultNoise77 = ( weightedBlend73 * staticSwitch75 * _NoiseMaskPower );
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 switchResult27 = (((ase_vface>0)?(float3(0,0,1)):(float3(0,0,-1))));
				float3 ase_worldTangent = IN.ase_texcoord4.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord5.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal8 = switchResult27;
				float3 worldNormal8 = float3(dot(tanToWorld0,tanNormal8), dot(tanToWorld1,tanNormal8), dot(tanToWorld2,tanNormal8));
				float dotResult1 = dot( ase_worldViewDir , worldNormal8 );
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth11 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth11 = abs( ( screenDepth11 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _MaskDepthFadeDistance ) );
				float clampResult19 = clamp( ( 1.0 - distanceDepth11 ) , 0.0 , 1.0 );
				float temp_output_10_0 = max( pow( ( 1.0 - dotResult1 ) , _MaskFresnelExp ) , pow( clampResult19 , _MaskDepthFadeExp ) );
				float clampResult80 = clamp( temp_output_10_0 , 0.0 , 1.0 );
				float clampResult125 = clamp( ( clampResult80 - pow( ( clampResult80 * _MaskSoftBordersMultiply ) , _MaskSoftBordersExp ) ) , 0.0 , 1.0 );
				#ifdef _MASKSOFTBORDERS_ON
				float staticSwitch128 = clampResult125;
				#else
				float staticSwitch128 = clampResult80;
				#endif
				float ResultOpacity93 = staticSwitch128;
				float4 fetchOpaqueVal97 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ( ase_grabScreenPosNorm + ( ResultNoise77 * _ScreenDistortionPower * ResultOpacity93 ) ).xy ), 1.0 );
				float4 temp_cast_4 = (ResultOpacity93).xxxx;
				#ifdef _VISUALIZEMASKDEBUG_ON
				float4 staticSwitch116 = temp_cast_4;
				#else
				float4 staticSwitch116 = fetchOpaqueVal97;
				#endif
				
				float temp_output_146_0 = abs( ( (0.0 + (IN.ase_texcoord6.xyz.y - 0.0) * (1.0 - 0.0) / (_MaskAppearLocalYRemap - 0.0)) + _MaskAppearLocalYAdd ) );
				#ifdef _MASKAPPEARINVERT_ON
				float staticSwitch153 = ( 1.0 - temp_output_146_0 );
				#else
				float staticSwitch153 = temp_output_146_0;
				#endif
				float2 uv0_MaskAppearNoise = IN.ase_texcoord7.xy * _MaskAppearNoise_ST.xy + _MaskAppearNoise_ST.zw;
				float4 triplanar148 = TriplanarSamplingSF( _MaskAppearNoise, ase_worldPos, ase_worldNormal, 1.0, _MaskAppearNoiseTriplanarTiling, 1.0, 0 );
				#ifdef _MASKAPPEARNOISETRIPLANAR_ON
				float staticSwitch149 = triplanar148.x;
				#else
				float staticSwitch149 = tex2D( _MaskAppearNoise, uv0_MaskAppearNoise ).r;
				#endif
				float2 appendResult156 = (float2(( staticSwitch153 + _MaskAppearProgress + -staticSwitch149 ) , 0.0));
				float MaskAppearValue159 = tex2D( _MaskAppearRamp, appendResult156 ).g;
				float NegatedOffset165 = -_NormalVertexOffset;
				float NegatedOffsetCE172 = NegatedOffset165;
				float4 FFSpherePositionsCE172 = _FFSpherePositions[0];
				float FFSphereSizesCE172 = _FFSphereSizes[0];
				float3 WorldPosCE172 = ase_worldPos;
				int FFSphereCountCE172 = (int)_FFSphereCount;
				float IOCE172 = _InterceptionOffset;
				float TFICE172 = _ThresholdForInterception;
				float2 localMyCustomExpression172 = MyCustomExpression172( NegatedOffsetCE172 , FFSpherePositionsCE172 , FFSphereSizesCE172 , WorldPosCE172 , FFSphereCountCE172 , IOCE172 , TFICE172 );
				float2 break186 = localMyCustomExpression172;
				float ifLocalVar179 = 0;
				if( break186.x > _ThresholdForSpheres )
				ifLocalVar179 = 1.0;
				else if( break186.x == _ThresholdForSpheres )
				ifLocalVar179 = 1.0;
				else if( break186.x < _ThresholdForSpheres )
				ifLocalVar179 = 0.0;
				float SpheresResult180 = ifLocalVar179;
				float clampResult187 = clamp( ( _InterceptionPower * break186.y ) , 0.0 , 1.0 );
				float HideInterceptionsMask189 = ( 1.0 - clampResult187 );
				float clampResult161 = clamp( ( MaskAppearValue159 * SpheresResult180 * HideInterceptionsMask189 ) , 0.0 , 1.0 );
				
		        float3 Color = staticSwitch116.rgb;
		        float Alpha = clampResult161;
		        float AlphaClipThreshold = 0;
			
			#if _AlphaClip
				clip(Alpha - AlphaClipThreshold);
			#endif

			#ifdef ASE_FOG
				Color = MixFog( Color, IN.fogCoord );
			#endif

			#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition (IN.clipPos.xyz, unity_LODFade.x);
			#endif

                return half4(Color, Alpha);
            }
            ENDHLSL
        }

		
        Pass
        {
			
            Name "DepthOnly"
            Tags { "LightMode"="DepthOnly" }

            ZWrite On
			ZTest LEqual
			ColorMask 0

            HLSLPROGRAM
            #define ASE_SRP_VERSION 60902
            #define ASE_TEXTURE_PARAMS(textureName) textureName
            

            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex vert
            #pragma fragment frag


            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

            #pragma shader_feature _MASKAPPEARINVERT_ON
            #pragma shader_feature _MASKAPPEARNOISETRIPLANAR_ON


			sampler2D _MaskAppearRamp;
			sampler2D _MaskAppearNoise;
			float4 _FFSpherePositions[20];
			float _FFSphereSizes[20];
			float _FFSphereCount;
			CBUFFER_START( UnityPerMaterial )
			float _NormalVertexOffset;
			float _Noise01Tiling;
			float _Noise01ScrollSpeed;
			float _NoiseDistortionTiling;
			float _NoiseDistortionPower;
			float _Noise02Tiling;
			float _Noise02ScrollSpeed;
			float _NoiseMaskPower;
			float _ScreenDistortionPower;
			float _MaskFresnelExp;
			float _MaskDepthFadeDistance;
			float _MaskDepthFadeExp;
			float _MaskSoftBordersMultiply;
			float _MaskSoftBordersExp;
			float _MaskAppearLocalYRemap;
			float _MaskAppearLocalYAdd;
			float _MaskAppearProgress;
			float4 _MaskAppearNoise_ST;
			float _MaskAppearNoiseTriplanarTiling;
			float _InterceptionOffset;
			float _ThresholdForInterception;
			float _ThresholdForSpheres;
			float _InterceptionPower;
			CBUFFER_END


			struct GraphVertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            struct VertexOutput
            {
                float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

			inline float4 TriplanarSamplingSF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
				yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
				zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
				return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
			}
			
			float2 MyCustomExpression172( float NegatedOffsetCE , float4 FFSpherePositionsCE , float FFSphereSizesCE , float3 WorldPosCE , int FFSphereCountCE , float IOCE , float TFICE )
			{
				float MyResult = 0;
				float DistanceMask45;
				float secondResult = 0;
				float secondResult2 = 0;
				for (int i = 0; i < FFSphereCountCE; i++){
				float myTempAdd = -((_FFSphereSizes[i] - 2) / 2);
				DistanceMask45 = distance( WorldPosCE , _FFSpherePositions[i] );
				float correctSize = (_FFSphereSizes[i] / 2) - NegatedOffsetCE;
				float ifA = (correctSize + IOCE - DistanceMask45);
				float ifB = (correctSize + IOCE) - (TFICE * correctSize);
				if (i == 0)
				{
				if (ifA > ifB)
				{
				secondResult = 0;
				}
				else
				{
				secondResult = ifA;
				}
				}
				else
				{
				if (ifA > ifB)
				{
				secondResult2 = 0;
				}
				else
				{
				secondResult2 = ifA;
				}
				secondResult = max(secondResult, secondResult2);
				}
				if (i == 0)
				{
				MyResult = (DistanceMask45 + myTempAdd + NegatedOffsetCE);
				}
				else
				{
				MyResult = min((DistanceMask45 + myTempAdd + NegatedOffsetCE), MyResult);
				}
				}
				float2 testt = float2(MyResult, secondResult);
				return testt;
			}
			

			VertexOutput vert( GraphVertexInput v  )
			{
					VertexOutput o = (VertexOutput)0;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
					float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
					
					float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
					o.ase_texcoord2.xyz = ase_worldPos;
					o.ase_texcoord3.xyz = ase_worldNormal;
					
					o.ase_texcoord = v.vertex;
					o.ase_texcoord1.xy = v.ase_texcoord.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord1.zw = 0;
					o.ase_texcoord2.w = 0;
					o.ase_texcoord3.w = 0;
					#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
					#else
					float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = ( ase_worldNormal * ( _NormalVertexOffset / ase_objectScale.x ) );	
					#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
					#else
					v.vertex.xyz += vertexValue;
					#endif
					v.ase_normal =  v.ase_normal ;
					o.clipPos = TransformObjectToHClip(v.vertex.xyz);
					return o;
			}

            half4 frag( VertexOutput IN  ) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
				float temp_output_146_0 = abs( ( (0.0 + (IN.ase_texcoord.xyz.y - 0.0) * (1.0 - 0.0) / (_MaskAppearLocalYRemap - 0.0)) + _MaskAppearLocalYAdd ) );
				#ifdef _MASKAPPEARINVERT_ON
				float staticSwitch153 = ( 1.0 - temp_output_146_0 );
				#else
				float staticSwitch153 = temp_output_146_0;
				#endif
				float2 uv0_MaskAppearNoise = IN.ase_texcoord1.xy * _MaskAppearNoise_ST.xy + _MaskAppearNoise_ST.zw;
				float3 ase_worldPos = IN.ase_texcoord2.xyz;
				float3 ase_worldNormal = IN.ase_texcoord3.xyz;
				float4 triplanar148 = TriplanarSamplingSF( _MaskAppearNoise, ase_worldPos, ase_worldNormal, 1.0, _MaskAppearNoiseTriplanarTiling, 1.0, 0 );
				#ifdef _MASKAPPEARNOISETRIPLANAR_ON
				float staticSwitch149 = triplanar148.x;
				#else
				float staticSwitch149 = tex2D( _MaskAppearNoise, uv0_MaskAppearNoise ).r;
				#endif
				float2 appendResult156 = (float2(( staticSwitch153 + _MaskAppearProgress + -staticSwitch149 ) , 0.0));
				float MaskAppearValue159 = tex2D( _MaskAppearRamp, appendResult156 ).g;
				float NegatedOffset165 = -_NormalVertexOffset;
				float NegatedOffsetCE172 = NegatedOffset165;
				float4 FFSpherePositionsCE172 = _FFSpherePositions[0];
				float FFSphereSizesCE172 = _FFSphereSizes[0];
				float3 WorldPosCE172 = ase_worldPos;
				int FFSphereCountCE172 = (int)_FFSphereCount;
				float IOCE172 = _InterceptionOffset;
				float TFICE172 = _ThresholdForInterception;
				float2 localMyCustomExpression172 = MyCustomExpression172( NegatedOffsetCE172 , FFSpherePositionsCE172 , FFSphereSizesCE172 , WorldPosCE172 , FFSphereCountCE172 , IOCE172 , TFICE172 );
				float2 break186 = localMyCustomExpression172;
				float ifLocalVar179 = 0;
				if( break186.x > _ThresholdForSpheres )
				ifLocalVar179 = 1.0;
				else if( break186.x == _ThresholdForSpheres )
				ifLocalVar179 = 1.0;
				else if( break186.x < _ThresholdForSpheres )
				ifLocalVar179 = 0.0;
				float SpheresResult180 = ifLocalVar179;
				float clampResult187 = clamp( ( _InterceptionPower * break186.y ) , 0.0 , 1.0 );
				float HideInterceptionsMask189 = ( 1.0 - clampResult187 );
				float clampResult161 = clamp( ( MaskAppearValue159 * SpheresResult180 * HideInterceptionsMask189 ) , 0.0 , 1.0 );
				

				float Alpha = clampResult161;
				float AlphaClipThreshold = AlphaClipThreshold;

			#if _AlphaClip
        		clip(Alpha - AlphaClipThreshold);
			#endif
                return 0;
			#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition (IN.clipPos.xyz, unity_LODFade.x);
			#endif
            }
            ENDHLSL
        }
		
    }
    Fallback "Hidden/InternalErrorShader"
	CustomEditor "ASEMaterialInspector"
	
}
/*ASEBEGIN
Version=17200
7;7;1906;1005;-498.3718;479.4207;1.3;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;139;1119.529,1915.652;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;119;898.683,473.8459;Float;False;Property;_NormalVertexOffset;Normal Vertex Offset;6;0;Create;True;0;0;False;0;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;1041.255,2206.19;Float;False;Property;_MaskAppearLocalYRemap;Mask Appear Local Y Remap;22;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;141;1364.488,2037.757;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;1266.369,2303.847;Float;False;Property;_MaskAppearLocalYAdd;Mask Appear Local Y Add;23;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;164;1326.274,578.4209;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;145;725.0651,2885.412;Float;False;Property;_MaskAppearNoiseTriplanarTiling;Mask Appear Noise Triplanar Tiling;29;0;Create;True;0;0;False;0;0.2;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;144;1598.407,2112.847;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;142;793.1097,2535.958;Inherit;False;0;143;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;143;828.7428,2675.099;Float;True;Property;_MaskAppearNoise;Mask Appear Noise;26;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;165;1471.274,575.4209;Float;False;NegatedOffset;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;171;-2247.728,-1418.494;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;170;-2258.564,-1275.847;Float;False;Global;_FFSphereCount;_FFSphereCount;43;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-2275.478,-1192.274;Float;False;Property;_InterceptionOffset;Interception Offset;31;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GlobalArrayNode;166;-2291.554,-1607.667;Inherit;False;_FFSphereSizes;0;20;0;False;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-2315.337,-1108.175;Float;False;Property;_ThresholdForInterception;Threshold For Interception;32;0;Create;True;0;0;False;0;1.001;1.001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;181;-2285.558,-1688.395;Inherit;False;165;NegatedOffset;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;147;1309.04,2589.101;Inherit;True;Property;_TextureSample6;Texture Sample 6;32;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;148;1254.041,2807.801;Inherit;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;-1;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GlobalArrayNode;169;-2284.507,-1514.809;Inherit;False;_FFSpherePositions;0;20;2;False;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.AbsOpNode;146;1799.113,2159.169;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;149;1694.311,2701.512;Float;False;Property;_MaskAppearNoiseTriplanar;Mask Appear Noise Triplanar;28;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;172;-1797.974,-1508.236;Float;False;float MyResult = 0@$float DistanceMask45@$float secondResult = 0@$float secondResult2 = 0@$$for (int i = 0@ i < FFSphereCountCE@ i++){$$float myTempAdd = -((_FFSphereSizes[i] - 2) / 2)@$DistanceMask45 = distance( WorldPosCE , _FFSpherePositions[i] )@$$float correctSize = (_FFSphereSizes[i] / 2) - NegatedOffsetCE@$float ifA = (correctSize + IOCE - DistanceMask45)@$float ifB = (correctSize + IOCE) - (TFICE * correctSize)@$$if (i == 0)${$if (ifA > ifB)${$secondResult = 0@$}$else${$secondResult = ifA@$}$}$else${$if (ifA > ifB)${$secondResult2 = 0@$}$else${$secondResult2 = ifA@$}$secondResult = max(secondResult, secondResult2)@$}$$if (i == 0)${$MyResult = (DistanceMask45 + myTempAdd + NegatedOffsetCE)@$}$else${$MyResult = min((DistanceMask45 + myTempAdd + NegatedOffsetCE), MyResult)@$}$}$$float2 testt = float2(MyResult, secondResult)@$return testt@;2;False;7;True;NegatedOffsetCE;FLOAT;0;In;;Float;False;True;FFSpherePositionsCE;FLOAT4;0,0,0,0;In;;Float;False;True;FFSphereSizesCE;FLOAT;0;In;;Float;False;True;WorldPosCE;FLOAT3;0,0,0;In;;Float;False;True;FFSphereCountCE;INT;0;In;;Float;False;True;IOCE;FLOAT;0;In;;Float;False;True;TFICE;FLOAT;0;In;;Float;False;My Custom Expression;True;False;0;7;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;INT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;150;1944.71,2073.368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;186;-1490.581,-1509.207;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StaticSwitch;153;2124.672,2131.298;Float;False;Property;_MaskAppearInvert;Mask Appear Invert;24;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-1514.502,-1709.804;Float;False;Property;_InterceptionPower;Interception Power;30;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;2144.242,2250.811;Float;False;Property;_MaskAppearProgress;Mask Appear Progress;25;0;Create;True;0;0;False;0;0;-0.5871994;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;152;2290.809,2348.457;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-1199.319,-1035.482;Float;False;Constant;_Float4;Float 4;25;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;191;-1154.116,-1622.523;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;154;2544.673,2196.297;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;2604.536,2430.712;Float;False;Constant;_Float6;Float 6;28;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;187;-992.4982,-1713.424;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;178;-1034.472,-1235.628;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-1297.903,-1124.167;Float;False;Property;_ThresholdForSpheres;Threshold For Spheres;33;0;Create;True;0;0;False;0;0.99;0.99;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-1191.004,-948.26;Float;False;Constant;_Float5;Float 5;25;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;156;2843.813,2285.008;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ConditionalIfNode;179;-891.7114,-1373.908;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;157;2985.134,2261.79;Inherit;True;Property;_MaskAppearRamp;Mask Appear Ramp;27;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;188;-857.9508,-1713.555;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;189;-696.1536,-1714.183;Float;False;HideInterceptionsMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;159;3309.227,2307.627;Float;False;MaskAppearValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;180;-714.7978,-1377.08;Float;False;SpheresResult;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectScaleNode;162;974.2736,237.4209;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;182;1072.915,-3.481842;Inherit;False;180;SpheresResult;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;190;1016.805,85.0101;Inherit;False;189;HideInterceptionsMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;1055.157,-123.8152;Inherit;False;159;MaskAppearValue;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;1325.915,-71.48184;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;117;1296.005,194.0876;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;163;1364.274,333.4209;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-594.3628,1697.967;Float;False;Property;_NoiseMaskPower;Noise Mask Power;8;0;Create;True;0;0;False;0;1;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;125;-621.595,350.2701;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;71;-1290.258,1159.294;Inherit;True;Property;_TextureSample4;Texture Sample 4;15;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;72;-1290.257,964.294;Inherit;True;Property;_TextureSample5;Texture Sample 5;15;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;75;-395.7968,2137.46;Float;False;Property;_Noise02Enabled;Noise 02 Enabled;13;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-608.4453,2228.068;Float;False;Constant;_Float8;Float 8;24;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SummedBlendNode;69;-638.4873,2083.742;Inherit;False;5;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SummedBlendNode;73;-676.6583,1151.494;Inherit;False;5;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;124;-770.2318,355.9167;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-2771.651,1348.873;Float;False;Property;_Noise01ScrollSpeed;Noise 01 Scroll Speed;12;0;Create;True;0;0;False;0;0.25;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;70;-1285.059,1364.694;Inherit;True;Property;_TextureSample3;Texture Sample 3;15;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;100;678.3059,-641.2544;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;41.76122,1522.642;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;1537.091,248.8321;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;2;-2743.878,-104.5229;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;116;1254.782,-406.4741;Float;False;Property;_VisualizeMaskDebug;Visualize Mask Debug;34;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;161;1653.604,-1.718933;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1776.266,318.2471;Float;False;Property;_NoiseMaskAdd;Noise Mask Add;9;0;Create;True;0;0;False;0;0.25;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;17;-1654.117,87.15874;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-1467.06,87.61079;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;35;-2709.356,2131.524;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;97;827.2896,-701.9072;Float;False;Global;_GrabScreen0;Grab Screen 0;21;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;98;388.4261,-731.6953;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-2391.312,2189.024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-1427.053,438.101;Float;False;Property;_MaskSoftBordersMultiply;Mask Soft Borders Multiply;4;0;Create;True;0;0;False;0;1.01;1.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-124.7478,171.5571;Float;False;ResultOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;187.3783,1519.921;Float;False;ResultNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;130;-4898.257,836.7032;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;79;-42.28455,-524.7101;Inherit;False;77;ResultNoise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-109.0102,-440.3779;Float;False;Property;_ScreenDistortionPower;Screen Distortion Power;21;0;Create;True;0;0;False;0;0.025;0.015;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;128;-415.7776,171.1426;Float;False;Property;_MaskSoftBorders;Mask Soft Borders;3;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;135;-3840.824,614.9592;Float;False;FinalWorldPosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;61;-1252.09,2091.542;Inherit;True;Property;_TextureSample0;Texture Sample 0;15;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;113;-46.94867,-350.4143;Inherit;False;93;ResultOpacity;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;122;-941.491,472.8224;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-3182.934,1666.395;Float;False;Property;_NoiseDistortionPower;Noise Distortion Power;19;0;Create;True;0;0;False;0;0.5;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;34;-3267.413,1472.142;Inherit;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;0;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-2429.483,1256.776;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-2433.435,1015.032;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-2192.434,2063.937;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;10;-1791.116,87.15874;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;134;-4127.17,614.1926;Float;False;Property;_LocalNoisePosition;Local Noise Position;7;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;-2764.385,1888.337;Inherit;False;135;FinalWorldPosition;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-2395.264,1947.28;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;12;-2406.171,292.9076;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-2747.957,1105.439;Float;False;Property;_Noise01Tiling;Noise 01 Tiling;11;0;Create;True;0;0;False;0;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;30;-3139.04,114.9353;Float;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;False;0;0,0,-1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;136;-2801.013,939.8776;Inherit;False;135;FinalWorldPosition;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TimeNode;45;-2747.524,1199.276;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;6;-2062.875,-134.5229;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;15;-2046.496,341.0779;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-2366.701,413.0777;Float;False;Property;_MaskDepthFadeExp;Mask Depth Fade Exp;2;0;Create;True;0;0;False;0;4;2;0.2;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2851.934,1575.395;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2709.789,2035.087;Float;False;Property;_Noise02Tiling;Noise 02 Tiling;15;0;Create;True;0;0;False;0;1;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2737.115,2276.125;Float;False;Property;_Noise02ScrollSpeed;Noise 02 Scroll Speed;16;0;Create;True;0;0;False;0;0.25;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;19;-2244.317,293.5592;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2390.876,-78.52291;Float;False;Property;_MaskFresnelExp;Mask Fresnel Exp;0;0;Create;True;0;0;False;0;4;0.2;0.2;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-2853.14,1677.703;Float;False;Constant;_Float3;Float 3;23;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;5;-2265.875,-170.5229;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;51;-2013.837,2065.614;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.Vector3Node;29;-3134.244,-49.72601;Float;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;80;-1289.148,188.9989;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;52;-1304.034,1671.071;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;64;-1555.548,1000.142;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;65;-1554.169,1154.476;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-912.6851,1667.138;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;62;-1246.89,2296.943;Inherit;True;Property;_TextureSample1;Texture Sample 1;15;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;66;-1629.734,1406.841;Float;True;Property;_Noise01;Noise 01;10;0;Create;True;0;0;False;0;None;None;True;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;67;-1552.788,1307.431;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;377.3232,-548.277;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;42;-2636.041,1614.004;Float;False;Property;_NoiseDistortionEnabled;Noise Distortion Enabled;17;0;Create;True;0;0;False;0;0;1;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;132;-4689.132,838.3857;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;31;-3604.521,1422.811;Float;True;Property;_NoiseDistortion;Noise Distortion;18;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SwitchByFaceNode;27;-2916.827,44.59443;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2873.172,291.9076;Float;False;Property;_MaskDepthFadeDistance;Mask Depth Fade Distance;1;0;Create;True;0;0;False;0;6;12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;-2230.604,1131.689;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;133;-4333.688,805.3687;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;63;-1252.089,1896.542;Inherit;True;Property;_TextureSample2;Texture Sample 2;15;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-1129.729,362.9962;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;1;-2389.876,-173.5228;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;3;-2733.878,-265.5228;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;8;-2741.878,42.47702;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;32;-3620.341,1615.138;Float;False;Property;_NoiseDistortionTiling;Noise Distortion Tiling;20;0;Create;True;0;0;False;0;0.5;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;11;-2601.171,293.9076;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;59;-1517.379,1932.391;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;55;-1591.566,2339.09;Float;True;Property;_Noise02;Noise 02;14;0;Create;True;0;0;False;0;None;None;True;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.AbsOpNode;57;-1080.388,1672.338;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;58;-2058.817,1124.857;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;56;-1515.999,2086.724;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-1264.202,571.6525;Float;False;Property;_MaskSoftBordersExp;Mask Soft Borders Exp;5;0;Create;True;0;0;False;0;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;54;-1514.62,2239.681;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;129;-5085.167,835.3986;Float;False;Constant;_Vector2;Vector 2;22;0;Create;True;0;0;False;0;0,0,0,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;131;-4890.282,692.9833;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;195;2098.864,-134.3223;Float;False;False;2;ASEMaterialInspector;0;1;Hidden/Templates/LightWeightSRPUnlit;e2514bdcf5e5399499a9eb24d175b9db;True;DepthOnly;0;2;DepthOnly;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=DepthOnly;True;0;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;193;2098.864,-134.3223;Float;False;True;2;ASEMaterialInspector;0;3;SineVFX/ForceFieldAndShieldEffects/ForceFieldDistortionMultipleLWRP;e2514bdcf5e5399499a9eb24d175b9db;True;Base;0;0;Base;5;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=LightweightForward;False;0;Hidden/InternalErrorShader;0;0;Standard;4;Vertex Position,InvertActionOnDeselection;1;Receive Shadows;1;Built-in Fog;0;LOD CrossFade;0;0;3;True;False;True;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;194;2098.864,-134.3223;Float;False;False;2;ASEMaterialInspector;0;1;Hidden/Templates/LightWeightSRPUnlit;e2514bdcf5e5399499a9eb24d175b9db;True;ShadowCaster;0;1;ShadowCaster;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
WireConnection;141;0;139;2
WireConnection;141;2;138;0
WireConnection;164;0;119;0
WireConnection;144;0;141;0
WireConnection;144;1;140;0
WireConnection;165;0;164;0
WireConnection;147;0;143;0
WireConnection;147;1;142;0
WireConnection;148;0;143;0
WireConnection;148;3;145;0
WireConnection;146;0;144;0
WireConnection;149;1;147;1
WireConnection;149;0;148;1
WireConnection;172;0;181;0
WireConnection;172;1;169;0
WireConnection;172;2;166;0
WireConnection;172;3;171;0
WireConnection;172;4;170;0
WireConnection;172;5;184;0
WireConnection;172;6;185;0
WireConnection;150;0;146;0
WireConnection;186;0;172;0
WireConnection;153;1;146;0
WireConnection;153;0;150;0
WireConnection;152;0;149;0
WireConnection;191;0;192;0
WireConnection;191;1;186;1
WireConnection;154;0;153;0
WireConnection;154;1;151;0
WireConnection;154;2;152;0
WireConnection;187;0;191;0
WireConnection;178;0;175;0
WireConnection;156;0;154;0
WireConnection;156;1;155;0
WireConnection;179;0;186;0
WireConnection;179;1;177;0
WireConnection;179;2;178;0
WireConnection;179;3;175;0
WireConnection;179;4;176;0
WireConnection;157;1;156;0
WireConnection;188;0;187;0
WireConnection;189;0;188;0
WireConnection;159;0;157;2
WireConnection;180;0;179;0
WireConnection;183;0;160;0
WireConnection;183;1;182;0
WireConnection;183;2;190;0
WireConnection;163;0;119;0
WireConnection;163;1;162;1
WireConnection;125;0;124;0
WireConnection;71;0;66;0
WireConnection;71;1;65;0
WireConnection;72;0;66;0
WireConnection;72;1;64;0
WireConnection;75;1;68;0
WireConnection;75;0;69;0
WireConnection;69;0;60;0
WireConnection;69;1;63;1
WireConnection;69;2;61;1
WireConnection;69;3;62;1
WireConnection;73;0;60;0
WireConnection;73;1;72;1
WireConnection;73;2;71;1
WireConnection;73;3;70;1
WireConnection;124;0;80;0
WireConnection;124;1;122;0
WireConnection;70;0;66;0
WireConnection;70;1;67;0
WireConnection;100;0;98;0
WireConnection;100;1;105;0
WireConnection;76;0;73;0
WireConnection;76;1;75;0
WireConnection;76;2;74;0
WireConnection;118;0;117;0
WireConnection;118;1;163;0
WireConnection;116;1;97;0
WireConnection;116;0;113;0
WireConnection;161;0;183;0
WireConnection;17;0;10;0
WireConnection;95;0;17;0
WireConnection;95;1;96;0
WireConnection;97;0;100;0
WireConnection;43;0;35;2
WireConnection;43;1;40;0
WireConnection;93;0;128;0
WireConnection;77;0;76;0
WireConnection;130;0;129;0
WireConnection;128;1;80;0
WireConnection;128;0;125;0
WireConnection;135;0;134;0
WireConnection;61;0;55;0
WireConnection;61;1;56;0
WireConnection;122;0;126;0
WireConnection;122;1;123;0
WireConnection;34;0;31;0
WireConnection;34;3;32;0
WireConnection;49;0;45;2
WireConnection;49;1;47;0
WireConnection;50;0;136;0
WireConnection;50;1;44;0
WireConnection;48;0;41;0
WireConnection;48;1;43;0
WireConnection;48;2;42;0
WireConnection;10;0;6;0
WireConnection;10;1;15;0
WireConnection;134;1;131;0
WireConnection;134;0;133;0
WireConnection;41;0;137;0
WireConnection;41;1;37;0
WireConnection;12;0;11;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;15;0;19;0
WireConnection;15;1;16;0
WireConnection;38;0;34;0
WireConnection;38;1;33;0
WireConnection;19;0;12;0
WireConnection;5;0;1;0
WireConnection;51;0;48;0
WireConnection;80;0;10;0
WireConnection;64;0;58;1
WireConnection;64;1;58;2
WireConnection;65;0;58;2
WireConnection;65;1;58;0
WireConnection;60;0;57;0
WireConnection;60;1;57;0
WireConnection;62;0;55;0
WireConnection;62;1;54;0
WireConnection;67;0;58;0
WireConnection;67;1;58;1
WireConnection;105;0;79;0
WireConnection;105;1;103;0
WireConnection;105;2;113;0
WireConnection;42;1;36;0
WireConnection;42;0;38;0
WireConnection;132;0;130;1
WireConnection;132;1;130;2
WireConnection;132;2;130;3
WireConnection;27;0;29;0
WireConnection;27;1;30;0
WireConnection;53;0;50;0
WireConnection;53;1;49;0
WireConnection;53;2;42;0
WireConnection;133;0;131;0
WireConnection;133;1;132;0
WireConnection;63;0;55;0
WireConnection;63;1;59;0
WireConnection;126;0;80;0
WireConnection;126;1;127;0
WireConnection;1;0;3;0
WireConnection;1;1;8;0
WireConnection;8;0;27;0
WireConnection;11;0;13;0
WireConnection;59;0;51;1
WireConnection;59;1;51;2
WireConnection;57;0;52;0
WireConnection;58;0;53;0
WireConnection;56;0;51;2
WireConnection;56;1;51;0
WireConnection;54;0;51;0
WireConnection;54;1;51;1
WireConnection;193;0;116;0
WireConnection;193;1;161;0
WireConnection;193;3;118;0
ASEEND*/
//CHKSM=1DE8576E888A1B4E177D6C6122726FAB92D01DE2