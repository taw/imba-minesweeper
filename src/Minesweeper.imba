let def randint(min, max)
  min + Math.floor(Math.random() * (max - min + 1))

export class Minesweeper
  def initialize(sizex, sizey, bomb_count)
    @sizex = sizex
    @sizey = sizey
    @bomb_count = bomb_count
    @tiles = {}
    @indexes = []
    @status = "playing"
    for x in [0...sizex]
      for y in [0...sizey]
        @tiles["{x},{y}"] = {bomb: false, status: "hidden"}
        @indexes.push([x,y])

    for i in [0...bomb_count]
      while true
        let x = randint(0, sizex - 1)
        let y = randint(0, sizey - 1)
        if !@tiles["{x},{y}"]:bomb
          @tiles["{x},{y}"]:bomb = true
          break

  def neighbour_indexes(x, y)
    let indexes = []
    for xx in [x - 1, x, x + 1]
      for yy in [y - 1, y, y + 1]
        continue if xx === x and yy === y
        continue unless @tiles["{xx},{yy}"]
        indexes.push([xx,yy])
    indexes


  def neighbour_bomb_count(x, y)
    let count = 0
    for _, index of neighbour_indexes(x, y)
      count += 1 if @tiles[index]:bomb
    count

  def reveal(x, y)
    return unless @tiles["{x},{y}"]:status === "hidden"
    @tiles["{x},{y}"]:status = "known"
    if @tiles["{x},{y}"]:bomb
      @status = "lost"
    if neighbour_bomb_count(x, y) === 0
      for index in neighbour_indexes(x, y)
        reveal(*index)
