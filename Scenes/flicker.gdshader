shader_type canvas_item;
//this value is a vector 3 of the red green blue values which can be edited in the inspector bcuz of uniform
uniform vec3 color : source_color = vec3(1.0);
//a value for the amount of mixing, also editable in inspector
uniform float amount :hint_range(0.0, 1.0) = 0.0;
void fragment() {
	//a vector 3 var for the original color for the pixels
	vec3 org_color = texture(TEXTURE, UV).rgb;
	//here we are setting each pixel to a mix of the original pixel color and the changed shader colors by an amount which we set
	COLOR.rgb = mix(org_color,color,amount);
}
