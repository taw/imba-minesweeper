let def randint(min, max)
  min + Math.floor(Math.random() * (max - min + 1))

export class Minesweeper
  def initialize(xsize, ysize, bomb_count)
    @bomb_count = bomb_count
    @xsize = xsize
    @ysize = ysize
    @cells = []
    @initialized = false

    for y in [0...ysize]
      for x in [0...xsize]
        let i = y * @xsize + x
        @cells.push({x: x, y: y, known: false, flag: false})

  # This only happens after first click, first click can never be a bomb
  def setup_bombs(x0, y0)
    @initialized = true

    # Initialize bombs
    let bombs = Set.new()
    while bombs:size < @bomb_count
      let x = randint(0, @xsize - 1)
      let y = randint(0, @ysize - 1)
      if x == x0 and y == y0
        continue
      bombs.add("{x},{y}")

    # Mark cells as having bombs
    for y in [0...@ysize]
      for x in [0...@xsize]
        cell_at(x,y):bomb = bombs.has("{x},{y}")

    # Calculate neighbours
    for x in [0...@xsize]
      for y in [0...@ysize]
        cell_at(x,y):n = count_neighbours(x, y)

  def cell_at(x, y)
    if x < 0 or x >= @xsize or y < 0 or y >= @ysize
      null
    else
      @cells[y * @xsize + x]

  def count_neighbours(x, y)
    let res = 0
    for xx in [x - 1, x, x + 1]
      for yy in [y - 1, y, y + 1]
        continue if xx === x and yy === y
        let cell = cell_at(xx, yy)
        if cell and cell:bomb
          res += 1
    res

  def reveal_click(cell)
    return if finished
    unless @initialized
      setup_bombs(cell:x, cell:y)
    reveal(cell)

  def reveal(cell)
    return if cell:known or cell:flag
    cell:known = true
    if cell:bomb
      for c in @cells
        c:known = true
      return
    let x = cell:x
    let y = cell:y
    if cell:n === 0
      for xx in [x - 1, x, x + 1]
        for yy in [y - 1, y, y + 1]
          continue if xx === x and yy === y
          let ncell = cell_at(xx, yy)
          if ncell
            reveal(ncell)

  def won
    @cells.every do |c|
      c:known === !c:bomb

  def lost
    @cells.some do |c|
      c:known and c:bomb

  def finished
    lost or won
