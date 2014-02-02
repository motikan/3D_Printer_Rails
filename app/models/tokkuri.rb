require_relative 'stl/stl'
require_relative 'stl/stl_reduce'
require_relative  'stl/util2d'

class Tokkuri
    THICKNESS = 0.15
    W, H = 200, 100
    def self.create imgfile
      rand2d = Rand2D.new W, H, 0.1, 0.5
      texture = Texture.new imgfile
      line=->z{[1+2*z-4*z**2+2*z**5, z]}
      stl = STL.new do
        reducepole W, H, 0.02 do |t1, z1|
          th = 2*Math::PI*t1
          pr,pz=0,0
          pos1,pos2=0.7,0.8
          if t = range(z1, 0..pos1)
            pr,pz=line.(t)
            tx,ty=1.2*t1,2*(1-t)-0.8
            pr*=1-THICKNESS/3*(1-texture.get(tx,ty)) if (0..1).include?(tx)&&(0..1).include?(ty)
          elsif t = range(z1, pos1..pos2)
            c=THICKNESS*(Math.cos(Math::PI*t)-1)/2
            s=THICKNESS*Math.sin(Math::PI*t)/2
            pr=1+c+s
            pz=1+s/4
          elsif t = range(z1, pos2..1)
            pr,pz=line.(1-t)
            pr-=THICKNESS
            pz=Math.sqrt((THICKNESS**2/16+pz**2)/(1+THICKNESS**2/16))
          end
          cos = Math.cos th
          sin = Math.sin th
          pr*=1-pz*pz/4
          twist_tmp=Math.exp(20*(pz-0.5))
          twist=twist_tmp/(1+twist_tmp)
          pr*=1+0.04*rand2d.get(t1+0.2*twist,pz)
          pz*=4
          pos={x:pr*cos,y:pr*sin,z:pz}
          effect = Math.exp(-pos[:x])*Math.exp(-pos[:y]*pos[:y])*Math.exp(2*(pos[:z]-4))
          pos[:z]*=1-0.015*effect
          pos[:y]*=1-0.5*(1-Math.exp(-effect*effect))
          pos[:x]*=1+0.05*effect
          pos[:x]*=20
          pos[:y]*=20
          pos[:z]*=20
          pos[:x]+=30
          pos
        end
      end
      stl.data
    end
  end
