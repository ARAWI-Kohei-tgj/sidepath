import settings;
import fontsize;
usepackage("newtx", "varg");
settings.outformat= "pdf";

import sidepath;

path unitsqure= (0, 1)--(0, 0)--(1, 0)--(1, 1)--cycle;

pen thl= linewidth(0.4bp)+miterjoin+squarecap+TimesRoman()+fontsize(10bp);
pen tcl= linewidth(0.8bp)+miterjoin+squarecap+Helvetica();
pen chain= linetype(new real[]{25, 3, 3, 3});
pen doublechain= linetype(new real[]{25, 3, 3, 3, 3, 3});
defaultpen(thl);
DefaultHead.size=new real(pen p=currentpen){return 6bp;};

real u= 5mm;
real width= 16u;
real height= 12u;
pair O= (0, 0);

// frame of this figure
draw(shift(-0.5width, -0.5height)*scale(width, height)*unitsqure, nullpen);

// level of equilibrium
draw((-0.3width, 0)--(0.3width, 0));

// U-shaped tube
real widUtube= 0.4width;
real diameter= 0.05width;
{
	real r= 0.1height;
	pair[] b= new pair[10];
	b[0]= (-0.5widUtube, 0.4height);
	b[1]= b[0]+(0.0, -0.8height+r);
	b[4]= b[1]+(r, -r);
	b[2]= b[1]+(0, -0.55r);
	b[3]= b[4]+(-0.55r, 0);

	path bone= b[0]--b[1]..controls b[2] and b[3]..b[4];
	bone= bone--reflect((0.0, -0.5height), (0.0, 0.5height))*reverse(bone);
	draw(bone, thl+chain);
	
	real st= 0.2;
	real en= 4.8;
	draw(sidePath(subpath(bone, st, en), diameter), tcl);

	real st= intersect(subpath(bone, 0, 1), (-0.5width, 0)--(0.5width, 0))[0];
	real en= intersect(subpath(bone, 4, 5), (-0.5width, 0)--(0.5width, 0))[0]+4;
	path[] tubeLen= sidePath(subpath(bone, st, en), 0.25u);
	draw(tubeLen[0]);

	pair p= (0.3width, -0.25height);
	draw(p--point(tubeLen[0], 4.5), Arrow);
	label("$L$", p, E);
}

// liquid column
{
	pair levelLeft= O+(-0.5widUtube, -2u);
	pair levelRight= O+(0.5widUtube, 2u);
	draw(levelLeft+(-0.5diameter, 0)--levelLeft+(0.5diameter, 0), tcl);
	draw(levelRight+(-0.5diameter, 0)--levelRight+(0.5diameter, 0), tcl);

	pair[] posLevel= {levelLeft, levelRight};
	pair[] p= new pair[4];
	for(pair pos: posLevel){
		p[0]= pos+(-0.4diameter, -0.1u);
		p[1]= pos+(0.3diameter, -0.1u);
		p[2]= pos+(-0.4diameter, -0.2u);
		p[3]= pos+(0.2diameter, -0.2u);
		draw(p[0]--p[1]);
		draw(p[2]--p[3]);
	}

	// diamter
	{
		pair pos= O+(-0.5widUtube, 2u);
		pair st= pos+(-0.5diameter-1.5u, 0);
		pair en= pos+(0.5diameter+u, 0);
		draw(st--pos+(-0.5diameter, 0), beveljoin, Arrow(arrowhead=SimpleHead));
		draw(en--pos+(0.5diameter, 0), beveljoin,  Arrow(arrowhead=SimpleHead));
		draw(pos+(-0.5diameter, 0)--pos+(0.5diameter, 0));
		label("$d$", st, NE);
		// ⌀
	}

	// gravity
	{
		pair st= (0.4width, 0.05height);
		pair en= (0.4width, -0.1height);
		draw(st--en, Arrow);
		label("$g$", 0.5*(st+en), E);
	}

	// rho
	{
		label("$\rho$", (-0.3width, -0.4height));
	}

	// height
	{
		pair st= levelRight+(-0.5diameter, 0);
		pair en= (0.1width-0.5u, levelRight.y);
		draw(st--en);

		st= (0.1width, levelRight.y);
		en= (0.1width, 0);
		draw(en--st, beveljoin, Arrow(arrowhead=SimpleHead));
		label(rotate(90)*"$z$", 0.5*(st+en), W);

		st= levelLeft+(0.5diameter, 0);
		en= (-0.1width+0.5u, levelLeft.y);
		draw(st--en);

		st= (-0.1width, levelLeft.y);
		en= (-0.1width, 0);
		draw(en--st, beveljoin, Arrow(arrowhead=SimpleHead));
		label(rotate(90)*"$-z$", 0.5*(st+en), W);
	}
}
