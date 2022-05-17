// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASESampleShaders/CosmosShader"
{
	Properties
	{
		_Color("Color", Color) = (0,0,0,0)
		_OpacityTex("OpacityTex", 2D) = "white" {}
		_OpacityNoiseTex("OpacityNoiseTex", 2D) = "white" {}
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Opacity("Opacity", Range( 0 , 1)) = 0.5
		_OpacityNoiseMult("OpacityNoiseMult", Range( 0 , 1)) = 0.5
		_ShieldAnimSpeedA("Shield Anim SpeedA", Range( -10 , 10)) = 3
		_ShieldAnimSpeedB("Shield Anim SpeedB", Range( -10 , 10)) = 3
		_NoAnimMainTex("NoAnimMainTex", Float) = 0
		_MinusOpacity("MinusOpacity", Float) = -0.112
		_Blesk("Blesk", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float4 _Color;
		uniform sampler2D _Albedo;
		uniform float _ShieldAnimSpeedA;
		uniform float _ShieldAnimSpeedB;
		uniform float _NoAnimMainTex;
		uniform sampler2D _OpacityNoiseTex;
		uniform float _OpacityNoiseMult;
		uniform float _Blesk;
		uniform sampler2D _OpacityTex;
		uniform float4 _OpacityTex_ST;
		uniform float _Opacity;
		uniform float _MinusOpacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float4 appendResult290 = (float4(( _Time.x * _ShieldAnimSpeedA ) , ( _Time.x * _ShieldAnimSpeedB ) , 0.0 , 0.0));
			float2 uv_TexCoord87 = i.uv_texcoord + ( appendResult290 * _NoAnimMainTex ).xy;
			float4 temp_output_278_0 = ( _Color * tex2D( _Albedo, uv_TexCoord87 ) * 4.0 );
			float2 uv_TexCoord302 = i.uv_texcoord + appendResult290.xy;
			float4 tex2DNode298 = tex2D( _OpacityNoiseTex, uv_TexCoord302 );
			float4 temp_output_299_0 = ( temp_output_278_0 + ( tex2DNode298 * _OpacityNoiseMult ) );
			o.Albedo = temp_output_299_0.rgb;
			o.Emission = temp_output_299_0.rgb;
			o.Metallic = 1.0;
			o.Smoothness = _Blesk;
			float2 uv_OpacityTex = i.uv_texcoord * _OpacityTex_ST.xy + _OpacityTex_ST.zw;
			float4 clampResult289 = clamp( ( ( tex2D( _OpacityTex, uv_OpacityTex ) * _Opacity ) + _MinusOpacity ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			o.Alpha = ( ( temp_output_278_0 * clampResult289 ) + ( tex2DNode298 * 0.245 ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

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
				float3 worldPos : TEXCOORD2;
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
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
100;358;1571;885;1495.817;1590.739;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;267;-2876.233,-1969.723;Inherit;False;830.728;358.1541;Comment;3;35;34;36;Animation Speed;1,1,1,1;0;0
Node;AmplifyShaderEditor.TimeNode;34;-2752.641,-1919.724;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;294;-2934.786,-1372.709;Float;False;Property;_ShieldAnimSpeedB;Shield Anim SpeedB;8;0;Create;True;0;0;0;False;0;False;3;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2826.233,-1726.569;Float;False;Property;_ShieldAnimSpeedA;Shield Anim SpeedA;7;0;Create;True;0;0;0;False;0;False;3;3.3;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-2510.105,-1796.31;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;295;-2618.658,-1442.45;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;290;-2341.662,-1517.543;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;300;-2381.865,-1366.661;Inherit;False;Property;_NoAnimMainTex;NoAnimMainTex;9;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1403.515,-1336.604;Float;False;Property;_Opacity;Opacity;5;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;286;-1509.755,-1773.343;Inherit;True;Property;_OpacityTex;OpacityTex;1;0;Create;True;0;0;0;False;0;False;-1;None;a8de9c9c15d9c7e4eaa883c727391bee;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;-2153.54,-1489.346;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;285;-1139.291,-1487.31;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;284;-1771.728,-2543.445;Inherit;False;837.0001;689.9695;Comment;4;278;128;277;304;Textures;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;87;-1973.527,-1640.313;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;288;-1173.888,-1130.951;Inherit;False;Property;_MinusOpacity;MinusOpacity;10;0;Create;True;0;0;0;False;0;False;-0.112;-0.83;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;277;-1715.328,-2302.676;Inherit;True;Property;_Albedo;Albedo;3;0;Create;True;0;0;0;False;0;False;-1;None;54d7aec97cb916047b0ef2fe9e52a349;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;302;-2497.796,-1146.229;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;304;-1352.901,-2129.906;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;287;-948.9504,-1363.894;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;128;-1694.224,-2493.445;Float;False;Property;_Color;Color;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;296;-1948.389,-1070.835;Float;False;Property;_OpacityNoiseMult;OpacityNoiseMult;6;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;-1340.928,-2334.676;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;289;-821.0876,-1318.251;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;298;-2252.861,-1162.381;Inherit;True;Property;_OpacityNoiseTex;OpacityNoiseTex;2;0;Create;True;0;0;0;False;0;False;-1;None;0d8a26cec82234c4f843595e1ae00caa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;308;-704.0587,-1015.269;Inherit;False;Constant;_adddd;adddd;10;0;Create;True;0;0;0;False;0;False;0.245;-0.83;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;309;-484.3587,-1075.069;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;297;-1677.665,-1298.241;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;305;-639.5741,-1348.086;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;307;-507.7589,-1228.467;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;303;-851.9231,-1423;Inherit;False;Property;_Blesk;Blesk;11;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;299;-965.6882,-1718.495;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;281;-622.7492,-1851.331;Inherit;True;Property;_Normal;Normal;4;0;Create;True;0;0;0;False;0;False;-1;None;302951faffe230848aa0d3df7bb70faa;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;306;-657.3176,-1513.784;Inherit;False;Constant;_Float1;Float 1;12;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-360.4059,-1540.498;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ASESampleShaders/CosmosShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;1;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;0;34;1
WireConnection;36;1;35;0
WireConnection;295;0;34;1
WireConnection;295;1;294;0
WireConnection;290;0;36;0
WireConnection;290;1;295;0
WireConnection;301;0;290;0
WireConnection;301;1;300;0
WireConnection;285;0;286;0
WireConnection;285;1;28;0
WireConnection;87;1;301;0
WireConnection;277;1;87;0
WireConnection;302;1;290;0
WireConnection;287;0;285;0
WireConnection;287;1;288;0
WireConnection;278;0;128;0
WireConnection;278;1;277;0
WireConnection;278;2;304;0
WireConnection;289;0;287;0
WireConnection;298;1;302;0
WireConnection;309;0;298;0
WireConnection;309;1;308;0
WireConnection;297;0;298;0
WireConnection;297;1;296;0
WireConnection;305;0;278;0
WireConnection;305;1;289;0
WireConnection;307;0;305;0
WireConnection;307;1;309;0
WireConnection;299;0;278;0
WireConnection;299;1;297;0
WireConnection;0;0;299;0
WireConnection;0;1;281;0
WireConnection;0;2;299;0
WireConnection;0;3;306;0
WireConnection;0;4;303;0
WireConnection;0;9;307;0
ASEEND*/
//CHKSM=929651B6B648B1D11676C3574772B43CACCAAB7F