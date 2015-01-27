TileType[][] GenerateWorld(int tiles_wide, int tiles_high, int num_rivers){
  
  TileType[][] res = new TileType[tiles_wide][tiles_high];
  //We're going to use this to represent the *hidden* height of tiles
  //Right now we use this to model 'natural' river flow, but maybe later this has other uses?
  float[][] heightmap = new float[tiles_wide][tiles_high];
  
  //First Law Of Generative Methods - all map generation must use Perlin noise
  for(int i=0; i<tiles_wide; i++){
     for(int j=0; j<tiles_high; j++){
         //We multiply by this extra factor to try and encourage a downward gradient
         heightmap[i][j] = noise(i, j) * ((tiles_high+1-j+1)/(tiles_high*0.6));
         res[i][j] = null;
     }
  } 
  
  
  for(int i=0; i<num_rivers; i++){
    if(random(1) < 0.9)
      RunRiverNaive(res, (int)random(tiles_wide));
    else
      RunRiverPerlin(res, heightmap, (int)random(tiles_wide));
  }
  
   return res; 
}

void RunRiverNaive(TileType[][] map, int x){
    int cx = x;
    map[cx][0] = TileType.RIVER;
    for(int i=0; i<map[0].length; i++){
        if(cx > 0 && random(1) < ((float)cx/(float)map.length)){
           cx--;
        } 
        else if(cx < map.length-1){
           cx++; 
        }
        map[cx][i] = TileType.RIVER;
        if(random(1) > 0.25 && i < map[0].length-1)
          map[cx][++i] = TileType.RIVER;
        if(random(1) > 0.75 && i < map[0].length-1)
          map[cx][++i] = TileType.RIVER;
    }
}

void RunRiverPerlin(TileType[][] map, float[][] hmap, int x){
   int rlength = 0;
   int rx = x; int ry = 0;
   map[rx][ry] = TileType.RIVER;
   float lowest_point = 1.0f; int lx = 0; int ly = 0;
   while(rlength < 100 && ry <= map[0].length-2){
     lowest_point = 1.0f;
     for(int i=-1; i<2; i++){
       for(int j=-1; j<2; j++){
         if(i == 0 && j == 0){continue;} 
         if(rx+i < 0 || ry+j < 0 || rx+i >= map.length || ry+j >= map[0].length) continue;
         if(map[rx+i][ry+j] == TileType.RIVER) continue;
         print(hmap[rx+i][ry+j]+" vs "+(hmap[rx][ry]+"\n"));
         if(hmap[rx+i][ry+j] < lowest_point){
           lowest_point = hmap[rx+i][ry+j];
           lx = i; ly = j;
         }
       }
     }
     rlength++;
     //If there was nowhere to go, then we should morph the landscape so the ground is lower
     if(lx == 0 && ly == 0){
        for(int i=-1; i<2; i++){
         for(int j=-1; j<2; j++){
           if(i == 0 && j == 0) continue;
           if(rx+i < 0 || ry+j < 0 || rx+i >= map.length || ry+j >= map[0].length) continue;
           if(map[rx+i][ry+j] == TileType.STONE) 
               hmap[rx+i][ry+j] *= 0.8;
         }
       }
       continue;
     }
     rx = rx+lx; ry = ry+ly;
     map[rx][ry] = TileType.RIVER;
     
   } 
}
