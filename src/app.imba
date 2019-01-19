import Minesweeper from "./Minesweeper"

tag Cell
  def onclick(event)
    unless data:known or data:flag
      trigger("reveal", data)

  def oncontextmenu(event)
    event.prevent
    unless data:known
      data:flag = !data:flag

  def render
    let cnt, cls

    if data:known
      if data:bomb
        cnt = "💣"
      else if data:n > 0
        cnt = "{ data:n }"
      else
        cnt = ""
        cls = "empty"
    else if data:flag
      cnt = "🚩"
    else
      cnt = ""
      cls = "unknown"
    cls ||= cnt

    <self .{"cell-{cls}"}>
      cnt

tag Game
  def onreveal(event, cell)
    data.reveal_click(cell)

  def render
    let cls1 = "x{data:_xsize}"
    let cls2 = "y{data:_ysize}"
    <self .{cls1} .{cls2}>
      for cell in data:_cells
        <Cell[cell]>

tag App
  def setup
    @game = null

  def render
    <self>
      <header>
        "Minesweeper"
      if @game
        <Game[@game]>
      if @game and @game.won
        <div.won>
          "You won!"
      if @game and @game.lost
        <div.lost>
          "You lost!"
      unless @game and !@game.finished
        <div>
          "Start a new game"
        <div.buttons>
          <button :click=(do @game = Minesweeper.new(8, 8, 10))>
            "Small"
          <button :click=(do @game = Minesweeper.new(16, 16, 40))>
            "Medium"
          <button :click=(do @game = Minesweeper.new(24, 24, 99))>
            "Big"

Imba.mount <App>
