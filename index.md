---
title: Home
---
# Flat top

<fieldset markdown='1'><legend>Coordinates</legend>
- `d` distance between hex centers equals 1pc
- `r` external circle radius equals `sqrt(3)d`
- hex center gaps
  - `ch` horizontal gap equals `3r/2` or `3sqrt(3)d/2`
  - `cv` vertical gap equals `sqrt(3)r/2` or `3d/2`
- hex vertex gaps
  - `vh` horizontal gap equals `r/2` or `sqrt(3)d/2`
  - `vv` vertical gap equals `sqrt(3)r/2` or `3d/2`
</fieldset>

## Map

{% assign span = 2 %}
{% assign low_span = span | minus: 1 %}
{% assign negative_span = span | times: -1 %}
{% assign width = span | plus: 0.25 | times: 1.732 %}
{% assign height = span | plus: 0.6 | times: 1.732 %}
<svg viewbox="-{{ width }} -{{ height }} {{ width | times: 2 }} {{ height | times: 2 }}" class='map'>
{%- for hx in (negative_span..span) -%}
  {%- assign x = hx | times: 1.5 -%}
  {% capture offset %}{% cycle 0.866, 0 %}{% endcapture %}
  {%- for hy in (negative_span..span) -%}
    {%- assign y = hy | times: 1.732 -%}
    {%- assign y = y | plus: offset -%}
    <!-- Distance -->
    {% assign xc = x | times: x %}
    {% assign yc = y | times: y %}
    {% assign dc = xc | plus: yc %}
    {% assign lower_gap = 0 %}
    {% assign upper_gap = 1 %}
    {% for i in (0..low_span) %}
      {% assign effimer = forloop.index | times: 1.732 %}
      {% assign effimer = effimer | times: effimer %}
      {% assign rounded = effimer | plus: 0.1 %}
      {% if rounded >= dc %}
        {% assign upper_gap = effimer | minus: dc %}
        {% if upper_gap > lower_gap %}
          {% assign distance = i %}
        {% else %}
          {% assign distance = forloop.index %}
        {% endif %}
        {% include widgets/hex.html distance=distance x=x y=y hx=hx hy=hy %}
        {% break %}
      {% else %}
        {% assign lower_gap = dc | minus: effimer %}
      {% endif %}
    {% endfor %}
  {%- endfor -%}
{%- endfor -%}
</svg>

## Orbits

Orbit **maps** are concentric, zoomable clicking central hex.

|Radius hexes|Orbit hexes = 6r
|:--|:--|
|1|6|
|2|12|
|3|18|
|4|24|
|5|30|

- Scale: 1 hex (example: 1pc or .5au)

Orbit hex length by orbit radius is: `{hex length}={orbit radius in hexes}*6`

- Body orbit {radius}: times 6 gives orbit path length
- Body {hex} position at unix=0
- Body {speed}: expressed as unix time to travel map scale distance (next hex) (example `datetime()` in 3 months)

### Physics

Stable orbits around Sol

- `r`: orbital radius (m) Earth `150x10^9 m`
- `t`: orbital period (s) Earth `31x10^6 s` (divided by `86400` in days)
  - `t=2 pi sqrt(1/(GM)) r^(3/2)=543 10^(-12) r^(3/2)`
- `v`: orbital velocity (m/s) Earth `30x10^3 m/s`
  - `v=sqrt(GM/r)` where `GM=1.34 10^20 (m^3/s^2)`

Orbital transfer with flip point and constant acceleration `A+B=C+D=1g` (m/s^2)

- Initial burn `t=0`
  - orbit 0
    - tangential: `v=v0`, `x=0`
    - radial: `x=r0`
  - orbit 1
    - tangential: `v=v1`, `x=d`
    - radial: `x=r1`
- Flip point h `t=T1`
  - body 0
    - tangential: `vth=v0+AT1`, `xth=v0T1+(AT1^2)/2`
    - radial: `vrh=BT1`, `xrh=r0+(BT1^2)/2`
  - orbit 1
    - tangential: `v=v1`, `x=v1T1+d`
    - radial: `x=r1`
- Final f
  - body 0
    - tangential: `vtf=v0+AT1-CT2`, `xtf=xth+vthT2-(CT2^2)/2`
    - radial: `vrf=BT1-DT2`, `xrf=xrh+(DT2^2)/2`
  - body 1
    - tangential: `v=v1`, `x=v1(T1+T2)+d`
    - radial: `x=r1`
- Intercept
  - tangential: `v0+AT1-CT2=v1`, `xth+vthT2-(CT2^2)/2=v1(T1=T2)+d`
  - radial: `BT1=DT2`, `r1=xrh+(DT2^2)/2`

### Galaxies

The **Local Volume** is a collection of more than 500 galaxies located in an area of the observable universe near us, within a spherical region with a radius of 11 megaparsecs.

`EcD`: (Yerkes) Elliptical supergiant diffuse have diameters 1kpc - 200kpc.

A **field galaxy** is a galaxy that does not belong to a larger galaxy group or cluster and hence is gravitationally alone.

Local group (diam=3Mpc) has mass 2 T Msol (trillion solar masses)

**Milky Way**

stars=250B, mass=1T, 100 satellite galaxies from 8kpc to 400kpc.

`SBc`: (Hubble) Barred spiral with loosely wound arms (type c).

- Bulge radius 3kpc
- Radius 13kpc
- Sun orbit radius 8kpc

Nearest M31 (stars=1T, mass=1T) is 750kpc away (1 hex with scale=1Mpc)

The mass of the Triangulum Galaxy (900kpc) is 10-40 B Msol (billion solar masses)

**Astronomenclature**

- Systems are named {parsec coordinate x,y,z}
- Stars are named {System} {Uppercase}
- Planets are named {Star} {lowercase}
- Moons are named {Planet} {R} where R is capital roman number.

### Star systems

From a star system point of view (0,0) with a scale of 1pc there are 6 neighborhoods.

**Solar system**

LIC is 10pc across.

- `000 A` (Sol) is `G 2V` G=yellow dwarf 2V=5,770K

Nearest:
- α Cen ABC oscillating around 1pc

Next ones:
- `-1-10 A` (α Oph A) at 2pc is `M 4V` (red dwarf, 76% abundance around, at 3,210K)
- `00-1 AB` (α Vel AB) at 2pc (binary brown dwarf: `L 7` and `T 0`)

1au = 150Mkm

- Inner system: 4 hexes (M, V, H, M), 1.5au 
- Outer system: 5 hexes (As, J, S, U, N), 30au
- Kuiper belt: 30au - 50au
- termination shock: 75au - 90au (solar wind subsonic)
- Oort cloud: 2kau - 200kau or .1pc - 1pc

**Giovian system**

- 4 hexes (Io 420k, Europa 670k, Ganymede 1M, Callisto 2M), scale .5Mkm

**Planet**

A spheric surface is mapped with 2 hex roses (pole and the 6 adjacent hexes per hemisphere)

For earth, north rose is centered on pole, NA, GR, EU, AS, AS, OC and the south rose is AF, OC, AU, OC, SA, OC.