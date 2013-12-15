require 'chunky_png'
#`gem install chunky_png` if /uninitialized constant ChunkyPNG (NameError)/
class Hash
  def method_missing name, *args
    if args.empty? && /^(?<key>[a-zA-Z0-9_]+)$/ =~ name
      self.[] key.to_sym
    elsif args.size == 1 && /^(?<key>[a-zA-Z0-9_]+)=$/ =~ name
      self.[]= key.to_sym, *args
    else
      super
    end
  end
end
 
def face p1,p2,p3,flip=false
  p2,p3=p3,p2 if flip
  nx = (p2.y-p1.y)*(p3.z-p1.z)-(p2.z-p1.z)*(p3.y-p1.y)
  ny = (p2.z-p1.z)*(p3.x-p1.x)-(p2.x-p1.x)*(p3.z-p1.z)
  nz = (p2.x-p1.x)*(p3.y-p1.y)-(p2.y-p1.y)*(p3.x-p1.x)
  nr = Math.sqrt(nx*nx+ny*ny+nz*nz)
  puts "facet normal #{nx/nr} #{ny/nr} #{nz/nr}"
  puts "outer loop"
  [p1,p2,p3].each do |p|
    puts "vertex #{p.x} #{p.y} #{p.z}"
  end
  puts "endloop"
  puts "endfacet"
end
 
def object name='name'
  puts "solid #{name}"
  begin
    yield
  ensure
    puts "endsolid #{name}"
  end
end
 
def pole coords, level, &block
  n=coords.size
  [0,1].each{|z|
    ps=coords.map{|h|h.z=z;h}
    p0={x:0,y:0,z:z}
    n.times do |i|
      face block.(p0,0),block.(ps[i-1],(i-1).fdiv(n)),block.(ps[i],i.fdiv(n)), z==0
    end
  }
  level.times do |lv|
    z0=lv.fdiv level
    z1=(lv+1).fdiv level
    n.times do |i|
      p1,p2=coords[i-1],coords[i]
      p1a,p1b=[p1.merge(z:z0),p1.merge(z:z1)]
      p2a,p2b=[p2.merge(z:z0),p2.merge(z:z1)]
      ph1,ph2=(i-1).fdiv(n),i.fdiv(n)
      face block.(p1a,ph1),block.(p2a,ph2),block.(p1b,ph1)
      face block.(p1b,ph1),block.(p2a,ph2),block.(p2b,ph2)
    end
  end
end
 
 
 
 
k=300
coords=k.times.map{|i|
  t=2*Math::PI*i/k
  {x:Math.cos(t)+0.1*Math.sin(3*t),y:Math.sin(t)+0.1*Math.cos(4*t)}
  #{x:Math.cos(t),y:Math.sin(t)}
}
 
img=ChunkyPNG::Image.from_file ARGV[0]
W=img.width
H=img.height
def img.get x,y
  return 0xff unless (0..W-2).include?(x)&&(0..H-2).include?(y)
  ix=x.floor
  iy=y.floor
  x-=ix
  y-=iy
  ChunkyPNG::Color.r(self[ix,iy])*(1-x)*(1-y)+
  ChunkyPNG::Color.r(self[ix+1,iy])*x*(1-y)+
  ChunkyPNG::Color.r(self[ix,iy+1])*(1-x)*y+
  ChunkyPNG::Color.r(self[ix+1,iy+1])*x*y
end
 
BASE_HEIGHT=0.3
CUP_HEIGHT=1.5
def line t
  r=0.8+0.4*(1-(1-t)**2)
  z=BASE_HEIGHT+CUP_HEIGHT*t
  [r,z]
end
 
object 'ochoko' do
  pole coords, 150 do |p, phase|
    t=p.z
    r,z=0,0
    th=0.1
    if t < 0.05
      t=t/0.05
      z=BASE_HEIGHT*t
      r=0.9-0.1*t
    elsif t < 0.75
      t=(t-0.05)/0.7
      r,z=line t
 
      x = phase*W
      y = (1-t)*H
      r*=1-th/3*(1-img.get(x,y).fdiv(255))
 
    elsif t < 0.85
      t=(t-0.75)/0.1
      z=CUP_HEIGHT+BASE_HEIGHT+Math.sin(Math::PI*t)*th/2
      r=1.2+(Math.cos(Math::PI*t)-1)*th/2
    else
      t=(t-0.85)/0.15
      r,z=line (1-t)
      r-=th
    end
    {
      x: r*p.x,
      y: r*p.y,
      z: z
    }
  end
 
 
end