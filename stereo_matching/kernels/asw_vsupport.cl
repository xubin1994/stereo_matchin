

__kernel void asw_vSupport (
	__read_only image2d_t input,
 __global float* output_cost
 )
{
   //x_width, y_height, z_support_window( <-16,16>\{0} )
    const int3 pos = {get_global_id(0), get_global_id(1), get_global_id(2)};
    const int2 dim = get_image_dim(input);

    float4 p;
    float4 q;

    float g_dist;
    float c_diff;
    float w;
   
    int y = clamp(pos.y + pos.z - 16, 0, dim.y - 1);
    p = read_imagef(input, sampler, (int2)(pos.x, pos.y)) * 255;
    q = read_imagef(input, sampler, (int2)(pos.x, y)) * 255;
    c_diff = (-1) * (fabs(p.x - q.x) + fabs(p.y - q.y) + fabs(p.z - q.z)) / 30.91f;

    g_dist = distance((float2)(pos.x, pos.y), (float2)(pos.x, y)) / 28.21f;
    w = exp(c_diff - g_dist);
    output_cost[pos.x + dim.x * pos.y + dim.x * dim.y * pos.z] = w;
}