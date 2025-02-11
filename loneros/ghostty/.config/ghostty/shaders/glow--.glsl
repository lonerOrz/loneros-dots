void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 source = toOklab(texture(iChannel0, uv));  // 获取原始颜色（背景）
    vec4 dest = source;  // 保留原始颜色

    vec3 glow = vec3(0.0);  // 初始化光晕效果

    // 光晕效果计算（Bloom）
    if (source.x > DIM_CUTOFF) {
        dest.x *= 1.5;  // 增强亮度，更强的发光效果
    } else {
        vec2 step = vec2(1.414) / iResolution.xy;  // 增大采样范围的步长

        // 扩展采样范围并增强光晕效果
        for (int i = 0; i < 24; i++) {
            vec3 s = samples[i];
            float weight = s.z;
            vec4 c = toOklab(texture(iChannel0, uv + s.xy * step));  // 采样周围像素

            if (c.x > DIM_CUTOFF) {
                // 增强光晕效果：增加对绿色和蓝色光晕的贡献
                glow.yz += c.yz * weight * 0.3;  // 提高光晕的绿色和蓝色分量
                if (c.x <= BRIGHT_CUTOFF) {
                    glow.x += c.x * weight * 0.1;  // 提高亮度部分的光晕强度
                } else {
                    glow.x += c.x * weight * 0.25;  // 提高亮区的权重，使光晕更强
                }
            }
        }
    }

    // 仅叠加光晕效果，不改变背景色
    dest.xyz += glow.xyz;  // 将光晕效果与背景叠加

    fragColor = toRgb(dest);  // 输出最终颜色
}

