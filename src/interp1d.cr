# Based on
# https://stackoverflow.com/questions/10258229/is-there-any-direct-function-to-perform-1d-data-interpolation-table-lookup

class Array
  def -(x : T) : self
    self + (-x)
  end

  def +(x : T) : self
    self.map { |element| element + x }
  end
end

module Interp1d
  VERSION = "0.1.0"

  # Quick additions to the Array class in order to be able to
  # add and subtract from scalar values

  def interpolate(x0 : Int32, y0 : Float64, x1 : Int32, y1 : Float64, x2 : Int32) : Float64
    y2 = y0.to_f + ((y1 - y0).to_f*(x2 - x0).to_f/(x1 - x0).to_f)
  end

  def interpolate(xs : Array(Int32), ys : Array(Float64), target : Int32) : Float64
    dist = (xs + target).map(&.abs)
    min_val_1 = dist.min
    min_loc_1 = dist.index min_val_1
    min_val_2 = dist.map_with_index { |v, i| min_loc_1 == i ? Float64::MAX : v }.min
    min_loc_2 = dist.index min_val_2
    if min_loc_1.nil? || min_loc_2.nil?
      raise "Couldn't locate min value"
    end
    interpolate(xs[min_loc_1], ys[min_loc_1], xs[min_loc_2], ys[min_loc_2], target)
  end

  def interp1d(xs : Array(Int32), vs : Array(Float64), xqs : Array(Int32)) : Array(Float64)
    vqs = Array.new(xqs.size) do |i|
      interpolate(xs, vs, xqs[i])
    end
  end

  # xs = [1950, 1960, 1970, 1980, 1990]
  # vs = [150.697, 179.323, 203.212, 226.505, 249.633]
  # xqs = (0..2000).to_a
  # interp1d(xs, vs, xqs)

end
