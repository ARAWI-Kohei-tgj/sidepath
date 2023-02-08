/*************************************************************
 * sidePathOne
 *
 * Generates offset curves of path of one segment
 *
 * Params:
 *  bone= original path (0 ≤ t ≤ 1)
 *  wid= half width
 *
 * Returns:
 *  The offset curves as path[] of length 2
 *  index=0 -> right side
 *  index=1 -> left side
 *
 *************************************************************/
path[] sidePathOne(path bone, real hwid){
	path[] result= new path[2];	// index= 0: right, index=1: left

	if(straight(bone, 0)){
		pair[] b= new pair[2];
		pair[] p= new pair[2];

		b[0]= point(bone, 0);
		b[1]= point(bone, 1);

		// right
		p[0]= b[0]+rotate(-90.0)*hwid*dir(bone, 0);
		p[1]= b[1]+rotate(-90.0)*hwid*dir(bone, 1);
		result[0]= p[0]--p[1];

		// left
		p[0]= b[0]+rotate(90.0)*hwid*dir(bone, 0);
		p[1]= b[1]+rotate(90.0)*hwid*dir(bone, 1);
		result[1]= p[0]--p[1];
	}
	else{
		pair[] b= new pair[4];
		pair[] p= new pair[4];

		b[0]= point(bone, 0);
		b[1]= postcontrol(bone, 0);
		b[2]= precontrol(bone, 1);
		b[3]= point(bone, 1);

		// right
		pair[] alpha= new pair[2];
		alpha[0]= rotate(-90.0)*hwid*dir(bone, 0);
		alpha[1]= rotate(90.0)*hwid*dir(bone, 0);

		pair[] beta= new pair[2];
		beta[0]= rotate(-90.0)*hwid*dir(bone, 1);
		beta[1]= rotate(90.0)*hwid*dir(bone, 1);

		transform[] turn= new transform[2];
		turn[0]= rotate(-90.0);
		turn[1]= rotate(90.0);

		for(int idx= 0; idx < 2; ++idx){
			p[0]= b[0]+alpha[idx];
			p[3]= b[3]+beta[idx];

			p[1]= 3.0/2.0*(
					2hwid*(turn[idx]*dir(bone, 1.0/3.0))
					-hwid*(turn[idx]*dir(bone, 2.0/3.0)))
				-1.0/6.0*(11*alpha[idx]-2*beta[idx])
				+(b[1]-b[0])
				+p[0];
			p[2]= 3.0/2.0*(
					-hwid*(turn[idx]*dir(bone, 1.0/3.0))
					+2hwid*(turn[idx]*dir(bone, 2.0/3.0)))
				-1.0/6.0*(-2*alpha[idx]+11*beta[idx])
				+(b[2]-b[3])
				+p[3];
			result[idx]= p[0]..controls p[1] and p[2]..p[3];
		}
	}
	return result;
}

/*************************************************************
 * sidePath
 *
 * Generates offset curves
 *
 * Params:
 *  bone= original path
 *  wid= full width
 *
 * Returns:
 *  The offset curves as path[] of length 2
 *  index=0 -> right side
 *  index=1 -> left side
 *************************************************************/
path[] sidePath(path bone, real wid){
	path[] temp;
	pair[] c= new pair[4];
	path[] result= new path[2];
	for(int st=0; st < length(bone); ++st){
		temp= sidePathOne(subpath(bone, st, st+1), 0.5wid);

		if(st == 0){
			result= temp;
		}
		else{
			for(int lr=0; lr < 2; ++lr){
				if(straight(temp[0], 0)){
					result[lr]= result[lr]--postcontrol(temp[lr], 1);
				}
				else{
					c[0]= precontrol(temp[lr], 0);
					c[1]= postcontrol(temp[lr], 0);
					c[2]= precontrol(temp[lr], 1);
					c[3]= postcontrol(temp[lr], 1);
					result[lr]= result[lr]..controls c[1] and c[2]..c[3];
				}
			}
		}
	}
	result[1]= reverse(result[1]);
	return result;
}
