#!/usr/bin/env bash

read N

function line {
  local length=$1
  for (( col = 0; col < $length; col=col+1 ))
  do
      echo -n '_'
  done
}
function lineShrag {
  local width=$1
  local fillsymbol=$2
  local shift=$3

  local half=$(( $width / 2 ))


  indx=$(( $half - $shift ))
  for (( col = 0; col < $indx; col=col+1 ))
  do
      echo -n '_'
  done
  echo -n $fillsymbol

  inter=$(( $shift + $shift ))
  for (( col = 1; col < $inter; col=col+1 ))
  do
      echo -n '_'
  done
  echo -n $fillsymbol

  for (( col = 1; col < $indx; col=col+1 ))
  do
      echo -n '_'
  done
}

function lineVertical {
  local left=$1
  local right=$2
  local fillsymbol=$3

  line $left
  echo -n $fillsymbol
  line $(($right-1))
}

function fractal {
  local width=$1
  local height=$2
  local fillsymbol=$3
  local quantity=$4
  local shifted=$5

  local half=$(( $width / 2 ))

  local pieceWidth=$(( $width / $quantity ))
  for (( row = $height; row > 0; row=row-1 ))
  do
    for (( piece = $quantity; piece > 0; piece=piece-1 ))
    do
      lineShrag $pieceWidth $fillsymbol $row
    done
    echo
  done

  for (( row = 0; row < $height; row=row+1 ))
  do
    local current=0
    local diff=$shifted
    local center=$(($half - $diff))

    for (( piece = $quantity; piece > 0; piece=piece-1 ))
    do
      lineVertical $center $half $fillsymbol
      # line $(($width - $center - $diff-1))
      echo
    done
  done
}

for (( row = 0; row < 47; row=row+1 ))
do
    for (( col = 1; col < 101; col=col+1 ))
    do
        echo -n '_'
    done
    echo
done

# fractal 100 8 1 2 16
fractal 100 16 1 1 0
