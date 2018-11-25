import Minesweeper from "./Minesweeper"

tag Cell < svg:g
  prop x
  prop y
  prop display
  prop cls

  def onclick
    trigger("reveal", [x, y])

  def render
    <self>
      <svg:rect .{cls} x=(30*x+1) y=(30*y+1) height=28 width=28>
      <svg:text x=(30*x+1+8) y=(30*y+1+15)>
        display

tag GameBoard
  def render
    <self>
      <div>
        "Game status is {data:_status}"
      <svg:svg#gameboard>
        for index in data:_indexes
          let x = index[0]
          let y = index[1]
          let t = data:_tiles["{x},{y}"]
          if t:status === "hidden"
            <Cell x=x y=y display="?" cls="unknown">
          else if t:bomb
            <Cell x=x y=y display="!" cls="bomb">
          else
            let b = data.neighbour_bomb_count(x, y)
            console.log("b is", x, y, b)
            if b === 0
              <Cell x=x y=y display="" cls="empty">
            else
              <Cell x=x y=y display=b cls="known">

tag MinesweeperGame
  def setup
    @playing = false
    @game = null

  def start(game)
    @playing = true
    @game = game

  def onreveal(ev, xy)
    @game.reveal(*xy)

  def render
    <self#game>
      if @game
        <GameBoard[@game]>
      if not @playing
        <div>
          "Start a new game"
        <div.buttons>
          <button :click=(do start Minesweeper.new(6, 6, 10))>
            "Small"
          <button :click=(do start Minesweeper.new(10, 10, 20))>
            "Medium"
          <button :click=(do start Minesweeper.new(14, 20, 40))>
            "Big"

tag App
  def render
    <self>
      <header>
        "Minesweeper"
      <MinesweeperGame>

Imba.mount <App>
