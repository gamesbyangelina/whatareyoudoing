String[] barks = new String[] {
  "Ooh, is it the seventh day already? Resting...", 
  "Reticulating river splines...", 
  "Redirecting salmon upstream...", 
  "Asking SpeedRock for 3000 boulder models...", 
  "Applying lichen...", 
  "Applying moss...", 
  "Removing moss from rolling stones...", 
  "Reconsidering initial act of creation...", 
  "Linking ELONMUSK.DLL... Loading...", 
  "Reconsidering chemical composition of water...", 
  "Adding in more emotions...", 
  "Decreeing arbitrary laws...", 
  "Killing all gamers...", 
  "Picking up and putting down stones...", 
  "Cancelling classes...",
};

boolean worldgen_debug = true;

TileType[][] GenerateWorld(int tiles_wide, int tiles_high, int num_rivers) {

  TileType[][] res = new TileType[tiles_wide][tiles_high];
  //We're going to use this to represent the *hidden* height of tiles
  //Right now we use this to model 'natural' river flow, but maybe later this has other uses?
  float[][] heightmap = new float[tiles_wide][tiles_high];

  //First Law Of Generative Methods - all map generation must use Perlin noise
  for (int i=0; i<tiles_wide; i++) {
    for (int j=0; j<tiles_high; j++) {
      //We multiply by this extra factor to try and encourage a downward gradient
      heightmap[i][j] = noise(i, j) * ((tiles_high+1-j+1)/(tiles_high*0.6));
      res[i][j] = null;
      
      if (heightmap[i][j] > 0.6 && random(1) < 0.05) {
        res[i][j] = TileType.STONE;
      }
      if (heightmap[i][j] < 0.3 && random(1) < 0.05) {
        res[i][j] = TileType.APPLE;
      }


      if (random(1) < 0.008) {
        if (worldgen_debug)
          print(barks[(int)random(barks.length)]+"\n");
      }
    }
  } 


  for (int i=0; i<num_rivers; i++) {
    if (random(1) < 0.6)
      RunRiverNaive(res, (int)random(tiles_wide));
    else {
      RunRiverPerlin(res, heightmap, int(random(tiles_wide)));
    }
  }

  return res;
}

void RunRiverNaive(TileType[][] map, int x) {
  int cx = x;
  map[cx][0] = TileType.RIVER;
  for (int i=0; i<map[0].length; i++) {
    if (cx > 0 && random(1) < ((float)cx/(float)map.length)) {
      cx--;
    } else if (cx < map.length-1) {
      cx++;
    }
    map[cx][i] = TileType.RIVER;
    if (random(1) > 0.25 && i < map[0].length-1)
      map[cx][++i] = TileType.RIVER;
    if (random(1) > 0.75 && i < map[0].length-1)
      map[cx][++i] = TileType.RIVER;
  }
}

void RunRiverPerlin(TileType[][] map, float[][] hmap, int x) {
  int rlength = 0;
  int rx = x; 
  int ry = 0;
  map[rx][ry] = TileType.RIVER;
  float lowest_point = 1.0f; 
  int lx = 0; 
  int ly = 0;
  while (rlength < 40 && ry <= map[0].length-2) {
    lowest_point = 1.0f;
    lx = 0; 
    ly = 0;
    for (int i=-1; i<2; i++) {
      for (int j=-1; j<2; j++) {
        if (i == 0 && j == 0) {
          continue;
        } 
        if (rx+i < 0 || ry+j < 0 || rx+i >= map.length || ry+j >= map[0].length) {
          continue;
        }
        if (map[rx+i][ry+j] == TileType.RIVER) {
          continue;
        }
        //print(hmap[rx+i][ry+j]+" vs "+(hmap[rx][ry]+"\n"));
        if (hmap[rx+i][ry+j] < lowest_point) {
          lowest_point = hmap[rx+i][ry+j];
          lx = i; 
          ly = j;
        }
      }
    }
    rlength++;
    //If there was nowhere to go, then we should morph the landscape so the ground is lower
    if (lx == 0 && ly == 0) {
      for (int i=-1; i<2; i++) {
        for (int j=-1; j<2; j++) {
          if (i == 0 && j == 0) continue;
          if (rx+i < 0 || ry+j < 0 || rx+i >= map.length || ry+j >= map[0].length) continue;
          if (map[rx+i][ry+j] == null) 
            hmap[rx+i][ry+j] *= 0.8;
        }
      }
      continue;
    }
    rx = rx+lx; 
    ry = ry+ly;
    map[rx][ry] = TileType.RIVER;
  }
}

class Pair {
  int x = -1;
  int y = -1;
  TileType t = null; 
  public Pair(int _x, int _y, TileType _t) {
    this.x = _x;
    this.y = _y;
    this.t = _t;
  }
}

boolean VerifyWorldState(TileType[][] map, int px, int py) {
  //First let's construct a useful floodplain of all the tiles that the player is connected to by land
  ArrayList<TileType> floodplain = new ArrayList<TileType>();
  ArrayList<Pair> tiles_to_visit = new ArrayList<Pair>();
  //Build a model of locations and visited status
  boolean[][] visited = new boolean[map.length][map[0].length];

  //Add the player's location to the open list
  tiles_to_visit.add(new Pair(px, py, map[px][py]));
  visited[px][py] = true;

  int rx; 
  int ry;

  while (tiles_to_visit.size () > 0) {
    if (worldgen_debug)
      print(tiles_to_visit.size()+" tiles remaining\n");
    //Get the next tile
    Pair p = tiles_to_visit.get(0); 
    tiles_to_visit.remove(0);
    visited[p.x][p.y] = true;
    rx = p.x; 
    ry = p.y;

    for (int i=-1; i<2; i++) {
      for (int j=-1; j<2; j++) {
        //Don't re-add yourself
        if (i == 0 && j == 0) continue;
        //Don't add out of bounds
        if (rx+i < 0 || ry+j < 0 || rx+i >= map.length || ry+j >= map[0].length) continue;
        //If you've already added this, ignore it
        if (visited[rx+i][ry+j]) continue;
        //Is this tile accessible diagonally? If not we can't technically reach it
        if (i != 0 && j != 0)
          continue;
        //Anything beyond here is in the floodplain
        floodplain.add(map[rx+i][ry+j]);
        //If it's a river or a stone, _don't_ add it to be visited
        if (map[rx+i][ry+j] == TileType.RIVER || map[rx+i][ry+j] == TileType.STONE) {
          continue;
        }
        boolean already_visiting = false;
        //If we've already arranged to visit the tile, don't visit it
        for (Pair tv : tiles_to_visit) {
          if (tv.x == rx+i && tv.y == ry+j) already_visiting = true;
        }
        if (already_visiting) {
          continue;
        }
        //Otherwise, schedule a visit
        else {
          tiles_to_visit.add(new Pair(rx+i, ry+j, map[rx+i][ry+j]));
        }
      }
    }
  }
  //We can add further conditions for world verification later
  //Current condition list:
  //1. The player must have a stone in its floodspace
  boolean has_stone = false;
  for (TileType t : floodplain) {
    if (t == TileType.STONE) {
      if (worldgen_debug)
        print("Has a stone");
      has_stone = true;
      break;
    }
  }
  if (!has_stone) return false;

  return true;
}

