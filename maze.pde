import ddf.minim.*;
Minim minim;//宣告
AudioPlayer music;//宣告
int stage = 0;  // 0: 主選單,2: 進入乘法遊戲, 3: 進入除法遊戲

MultiplyGame multiplyGame;
DivideGame divideGame;
SubtractGame subtractGame;
DivisibleGame divisibleGame;

PFont TCfont;

PImage imgTitle, imgWall, imgWall2, imgDark, imgPara, imgBtlBG, imgEnemy;
PImage[] imgItem = new PImage[5];
PImage[] imgFloor = new PImage[4];
PImage[] imgPlayer = new PImage[9];
PImage[] imgEffect = new PImage[2];

PFont font, fontS;

int speed, idx, tmr, floor, fl_max, welcome, pl_x, pl_y, pl_d, pl_a, pl_lifemax, pl_life,
    pl_str, food, potion, blazegem, treasure, emy_lifemax, emy_life, emy_str, emy_x,
    emy_y, emy_step, emy_blink, dmg_eff, btl_cmd, dmg, lif_p, str_p, bx, by, h, d, dx, dy, col, Xpos, Ypos, x, y, r;
//idx=0->title ; idx=1->dungeon(player) ; idx=2->switching   ; idx=3->get props || traps ; idx=4->hep ; idx=5->about_us ; idx=9->game over
int MAZE_W = 11;
int MAZE_H = 9;
int DUNGEON_W = MAZE_W * 3;
int DUNGEON_H = MAZE_H * 3;
int[][] maze = new int[MAZE_H][MAZE_W];
int[][] dungeon = new int[DUNGEON_H][DUNGEON_W];
int[] PL_TURN = {2, 4, 0, 6};
int[] XP = {0, 1, 0, -1};
int[] YP = {-1, 0, 1, 0};

int WHITE = color(255, 255, 255);
int BLACK = color(0, 0, 0);
int RED = color(255, 0, 0);
int CYAN = color(0, 255, 255);
color[] BLINK = {
  color(224, 255, 255), 
  color(192, 240, 255), 
  color(128, 224, 255), 
  color(64, 192, 255), 
  color(128, 224, 255), 
  color(192, 240, 255)
};

String emy_name;
String[] COMMAND = {"[A]ttack", "[P]otion", "[B]laze gem", "[R]un"};
String[] TRE_NAME = {"Potion", "Blaze gem", "Food spoiled.", "Food +20", "Food +100"};
String[] EMY_NAME = {
  "Green slime", "Red slime", "Axe beast", "Ogre", "Sword man", 
  "Death hornet", "Signal slime", "Devil plant", "Twin killer", "Hell"
};

 //<>//
void setup(){
  frameRate(360);
  imgTitle = loadImage("title.png");
  imgWall = loadImage("wall.png");
  imgWall2 = loadImage("wall2.png");
  imgDark = loadImage("dark.png");
  imgPara = loadImage("parameter.png");
  imgBtlBG = loadImage("btlbg.png");
  imgEnemy = loadImage("enemy0.png");
  
  imgItem[0] = loadImage("potion.png");
  imgItem[1] = loadImage("blaze_gem.png");
  imgItem[2] = loadImage("spoiled.png");
  imgItem[3] = loadImage("apple.png");
  imgItem[4] = loadImage("meat.png");
  
  imgFloor[0] = loadImage("floor.png");
  imgFloor[1] = loadImage("tbox.png");
  imgFloor[2] = loadImage("cocoon.png");
  imgFloor[3] = loadImage("stairs.png");
  
  imgPlayer[0] = loadImage("mychr0.png");
  imgPlayer[1] = loadImage("mychr1.png");
  imgPlayer[2] = loadImage("mychr2.png");
  imgPlayer[3] = loadImage("mychr3.png");
  imgPlayer[4] = loadImage("mychr4.png");
  imgPlayer[5] = loadImage("mychr5.png");
  imgPlayer[6] = loadImage("mychr6.png");
  imgPlayer[7] = loadImage("mychr7.png");
  imgPlayer[8] = loadImage("mychr8.png");
  
  imgEffect[0] = loadImage("effect_a.png");
  imgEffect[1] = loadImage("effect_b.png");

  speed = 1;
  idx = 0;
  tmr = 0;
  floor = 0;
  fl_max = 1;
  welcome = 0;

  pl_x = 0;
  pl_y = 0;
  pl_d = 0;
  pl_a = 0;
  pl_lifemax = 0;
  pl_life = 0;
  pl_str = 0;
  food = 0;
  potion = 0;
  blazegem = 0;
  treasure = 0;

  emy_name = "";
  emy_lifemax = 0;
  emy_life = 0;
  emy_str = 0;
  emy_x = 0;
  emy_y = 0;
  emy_step = 0;
  emy_blink = 0;

  dmg_eff = 0;
  btl_cmd = 0;
  
  dmg = 0;
  lif_p = 0;
  str_p = 0;

  for(int y = 1;y < MAZE_H;y++){
    maze[y] = new int[MAZE_W];
  }

  for(int y = 1;y < DUNGEON_H;y++){
    dungeon[y] = new int[DUNGEON_W];
  }
  
  size(880, 720);//視窗大小
  background(#EEEEEE);//背景  
  
  surface.setTitle("One hour Dungeon");//視窗名字
  surface.setResizable(false);//不允許改變視窗大小
  surface.setLocation(100, 100); //視窗起始位置
  
  //設定字型、字體大小
  TCfont = createFont("NotoSansTC-Regular.ttf", 28);
  font = createFont("NotoSansTC-VariableFont_wght.ttf", 40);
  fontS = createFont("NotoSansTC-VariableFont_wght.ttf", 30);
  //clock
  minim = new Minim(this);//設定minim變數
  multiplyGame = new MultiplyGame(this, TCfont);
  divideGame = new DivideGame();
  subtractGame = new SubtractGame();
}

void draw(){
  if(keyPressed){
    if(key == 'p'){
      speed++;
      if(speed == 4){
        speed = 1;
      }
      delay(50);
    }
  }    
  
  tmr++;

  if(idx == 0){ //標題畫面
    if(tmr == 1){
      music = minim.loadFile("ohd_bgm_title.mp3");
      music.loop();
    }
    background(WHITE);
    if(fl_max >= 2){
      fill(CYAN);
      textFont(font);
      text("You reached floor "+str(fl_max)+".", 300, 460);
    }
    fill(BLINK[tmr%6]);
    textFont(font);
    drawMainMenu();
    if (mouseX > 340 && mouseX < 540 && mouseY > 280 && mouseY < 340 && mousePressed){
      background(WHITE);
      make_dungeon();
      put_event();
      floor = 1;
      welcome = 15;
      pl_lifemax = 300;
      pl_life = pl_lifemax;
      pl_str = 100;
      food = 300;
      potion = 0;
      blazegem = 0;
      idx = 1;
      minim.stop();
      music = minim.loadFile("ohd_bgm_field.mp3");
      music.loop();
    }
    
    //help
    if (mouseX > 340 && mouseX < 540 && mouseY > 380 && mouseY < 440 && mousePressed){
      idx=4;
    }
    
    //aboutUs
    if (mouseX > 340 && mouseX < 540 && mouseY > 480 && mouseY < 540 && mousePressed){
      idx=5;
    }
  }
  else if(idx==4){
      draw_help();
  }
  else if(idx==5){
     draw_aboutUs();
  }
  
  else{
    if(idx == 1){ //玩家的移動
      move_player();
      draw_dungeon(1);
      fill(WHITE);
      textFont(fontS);
      text("floor "+str(floor)+" ("+str(pl_x)+","+str(pl_y)+")", 60, 40);
      if(welcome > 0){
        welcome--;
        fill(CYAN);
        textFont(font);
        text("Welcome to floor "+str(floor)+".", 300, 180);
      }
    }
    else{
      if(idx == 2){ //切換畫面
        draw_dungeon(1);
        if(1 <= tmr && tmr <= 5){
          h = 80*tmr;
          fill(BLACK);
          rect(0, 0, 880, h);
          rect(0, 720-h, 880, h);
        }
        if(tmr == 5){
          floor++;
          if(floor > fl_max){
            fl_max = floor;
          }
          welcome = 15;
          make_dungeon();
          put_event();
        }
        if(6 <= tmr && tmr <= 9){
          h = 80*(10-tmr);
          fill(BLACK);
          rect(0, 0, 880, h);
          rect(0, 720-h, 880, h);
        }
        if(tmr == 10){
          idx = 1;
        }
      }

      else{
        if(idx == 3){ //取得道具或踩到陷阱
          draw_dungeon(1);
          image(imgItem[treasure], 320, 220);
          fill(WHITE);
          textFont(font);
          text(TRE_NAME[treasure], 380, 240);
          if(tmr == 10){
            idx = 1;
          }
        }
        else{
          if(idx == 9){ //遊戲結束
            if(tmr <= 30){
              pl_a = PL_TURN[tmr%4];
              if(tmr == 30) pl_a = 8; //主角倒地的畫面
              draw_dungeon(1);
            }
            else{
              if(tmr == 31){
                music = minim.loadFile("ohd_jin_gameover.mp3");
                music.play();
                fill(RED);
                textFont(font);
                text("You died.", 360, 240);
                text("Game over.", 360, 380);
              }
              else{
                if(tmr == 100){
                  idx = 0;
                  tmr = 0;
                }
              }
            }
          }

          else{
            if(idx == 10){ //開始戰鬥
              if(tmr == 1){
                minim.stop();
                music = minim.loadFile("ohd_bgm_battle.mp3");
                music.loop();
              }
              else{
                if(tmr <= 4){
                  bx = (4-tmr)*220;
                  by = 0;
                  image(imgBtlBG, bx, by);
                  fill(WHITE);
                  textFont(font);
                  text("Encounter!", 350, 200);
                  stage = int(random(1, 5));
                }
                else{
                  if(tmr > 4){
                    switch(stage){
                      case 1:
                        subtractGame.display();
                        break;
                      case 2:
                        multiplyGame.display();
                        break;
                      case 3:
                        divideGame.display();
                        break;
                      case 4:
                        divisibleGame.display();
                        break;
                    }
                  }
                }
              }
            }

            else{
              if(idx == 11){ //輪到玩家攻擊(等待指令輸入)
                //draw_battle(screen, fontS);
                if(tmr == 1) ;//set_message("Your turn.");
                /*if(battle_command(screen, font, key) == true){
                  if(btl_cmd == 0){
                    idx = 12;
                    tmr = 0;
                  }
                  if(btl_cmd == 1 && potion > 0){
                    idx = 20;
                    tmr = 0;
                  }
                  if(btl_cmd == 2 && blazegem > 0){
                    idx = 21;
                    tmr = 0;
                  }
                  if(btl_cmd == 3){
                    idx = 14;
                    tmr = 0;
                  }
                }*/
              }

              else{
                if(idx == 12){ //玩家發動攻擊
                  //draw_battle(screen, fontS);
                  if(tmr == 1){
                    //set_message("You attack!");
                    music = minim.loadFile("ohd_se_attack.mp3");
                    music.play();
                    dmg = pl_str + int(random(0, 10));
                  }
                  if(2 <= tmr && tmr <= 4){
                    image(imgEffect[0], 700-tmr*120, -100+tmr*120);
                  }
                  if(tmr == 5){
                    emy_blink = 5;
                    //set_message(str(dmg)+"pts of damage!");
                  }
                  if(tmr == 11){
                    emy_life = emy_life - dmg;
                    if(emy_life <= 0){
                      emy_life = 0;
                      idx = 16;
                      tmr = 0;
                    }
                  }
                  if(tmr == 16){
                    idx = 13;
                    tmr = 0;
                  }
                }

                else{
                  if(idx == 13){ //輪到敵人攻擊
                    //draw_battle(screen, fontS);
                    if(tmr == 1){
                      //set_message("Enemy turn.");
                    }
                    if(tmr == 5){
                      //set_message(emy_name + " attack!");
                      music = minim.loadFile("ohd_se_attack.mp3");
                      music.play();
                      emy_step = 30;
                    }
                    if(tmr == 9){
                      dmg = emy_str + int(random(0, 10));
                      //set_message(str(dmg)+"pts of damage!");
                      dmg_eff = 5;
                      emy_step = 0;
                    }
                    if(tmr == 15){
                      pl_life = pl_life - dmg;
                      if(pl_life < 0){
                        pl_life = 0;
                        idx = 15;
                        tmr = 0;
                      }
                    }
                    if(tmr == 20){
                      idx = 11;
                      tmr = 0;
                    }
                  }

                  else{
                    if(idx == 14){ //逃得掉嗎?
                      //draw_battle(screen, fontS);
                      if(tmr == 1) //set_message("...");
                      if(tmr == 2) //set_message("......");
                      if(tmr == 3) //set_message(".........");
                      if(tmr == 4) //set_message("............");
                      if(tmr == 5){
                        if(random(0, 100) < 60){
                          idx = 22;
                        }
                        else{
                          //set_message("You failed to flee.");
                        }
                      }
                      if(tmr == 10){
                        idx = 13;
                        tmr = 0;
                      }
                    }

                    else{
                      if(idx == 15){ //失敗
                        //draw_battle(screen, fontS);
                        if(tmr == 1){
                          minim.stop();
                          //set_message("You lose.");
                        }
                        if(tmr == 11){
                          idx = 9;
                          tmr = 29;
                        }
                      }

                      else{
                        if(idx == 16){ //勝利
                          //draw_battle(screen, fontS);
                          if(tmr == 1){
                            //set_message("You win!");
                            minim.stop();
                            music = minim.loadFile("ohd_jin_win.mp3");
                            music.play();
                          }
                          if(tmr == 28){
                            idx = 22;
                            if(random(0, emy_lifemax+1) > random(0, pl_lifemax+1)){
                              idx = 17;
                              tmr = 0;
                            }
                          }
                        }

                        else{
                          if(idx == 17){ //升級
                            //draw_battle(screen, fontS);
                            if(tmr == 1){
                              //set_message("Level up!");
                              music = minim.loadFile("ohd_jin_levup.mp3");
                              music.play();
                              lif_p = int(random(10, 21));
                              str_p = int(random(5, 11));
                            }
                            if(tmr == 21){
                              //set_message("Max life + "+str(lif_p));
                              pl_lifemax = pl_lifemax + lif_p;
                            }
                            if(tmr == 26){
                              //set_message("Str + "+str(str_p));
                              pl_str = pl_str + str_p;
                            }
                            if(tmr == 50){
                              idx = 22;
                            }
                          }

                          else{
                            if(idx == 20){ //Potion
                              //draw_battle(screen, fontS);
                              if(tmr == 1){
                                //set_message("Potion!");
                                music = minim.loadFile("ohd_se_potion.mp3");
                                music.play();
                              }
                              if(tmr == 6){
                                pl_life = pl_lifemax;
                                potion = potion - 1;
                              }
                              if(tmr == 11){
                                idx = 13;
                                tmr = 0;
                              }
                            }

                            else{
                              if(idx == 21){ //Blaze gem
                                //draw_battle(screen, fontS);
                                pushMatrix();
                                translate(width/2, height/2);
                                rotate(30*tmr);
                                scale((12-tmr)/8);
                                imageMode(CENTER);
                                image(imgEffect[1], 0, 0);
                                popMatrix();
                                /*img_rz = pygame.transform.rotozoom(imgEffect[1], 旋轉角30*tmr, 縮放比(12-tmr)/8)
                                X = 440-img_rz.get_width()/2
                                Y = 360-img_rz.get_height()/2
                                screen.blit(img_rz, [X, Y])*/
                                if(tmr == 1){
                                  //set_message("Blaze gem!");
                                  music = minim.loadFile("ohd_se_blaze.mp3");
                                  music.play();
                                }
                                if(tmr == 6){
                                  blazegem = blazegem - 1;
                                }
                                if(tmr == 11){
                                  dmg = 1000;
                                  idx = 12;
                                  tmr = 4;
                                }
                              }

                              else{
                                if(idx == 22){ //戰鬥結束
                                  music = minim.loadFile("ohd_bgm_field.mp3");
                                  music.loop();
                                  idx = 1;
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  

  fill(WHITE);
  textFont(fontS);
  text("S[p]eed"+str(speed), 740, 40);

  if(idx != 10){
      delay(250-17*(4+2*speed));
  }
}

void make_dungeon(){ //自動產生地下城
    //周圍的牆壁
    for(int x = 0;x < MAZE_W;x++){
        maze[0][x] = 1;
        maze[MAZE_H-1][x] = 1;
    }
    for(int y = 1;y < MAZE_H-1;y++){
        maze[y][0] = 1;
        maze[y][MAZE_W-1] = 1;
    }
    //地下城一片空白的狀態
    for(int y = 1;y < MAZE_H-1;y++){
        for(int x = 1;x < MAZE_W-1;x++){
            maze[y][x] = 0;
        }
    }
    //柱子
    for(int y = 2;y < MAZE_H-2;y = y+2){
        for(int x = 2;x < MAZE_W-2;x = x+2){
            maze[y][x] = 1;
        }
    }
    //從柱子的上下左右延伸出牆壁
    for(int y = 2;y < MAZE_H-2;y = y+2){
        for(int x = 2;x < MAZE_W-2;x = x+2){
            d = int(random(0, 4));
            if(x > 2){//自第二欄的柱子之後，不在左側建立牆壁
                d = int(random(0, 3));
            }
            maze[y+YP[d]][x+XP[d]] = 1;
        }
    }

    //根據迷宮建立地下城
    //將地下城的所有空間設定為牆壁
    for(int y = 0;y < DUNGEON_H;y++){
        for(int x = 0;x < DUNGEON_W;x++){
            dungeon[y][x] = 9;
        }
    }
    //配置房間與通道
    for(int y = 1;y < MAZE_H-1;y++){
        for(int x = 1;x < MAZE_W-1;x++){
            dx = x*3+1;
            dy = y*3+1;
            if(maze[y][x] == 0){
                if(random(0, 101) < 20){ //建立房間
                    for(int ry = -1;ry < 2;ry++){
                        for(int rx = -1;rx < 2;rx++){
                            dungeon[dy+ry][dx+rx] = 0;
                        }
                    }
                }
                else{ //建立通道
                    dungeon[dy][dx] = 0;
                    if(maze[y-1][x] == 0){
                        dungeon[dy-1][dx] = 0;
                    }
                    if(maze[y+1][x] == 0){
                        dungeon[dy+1][dx] = 0;
                    }
                    if(maze[y][x-1] == 0){
                        dungeon[dy][dx-1] = 0;
                    }
                    if(maze[y][x+1] == 0){
                        dungeon[dy][dx+1] = 0;
                    }
                }
            }
        }
    }
}

void draw_dungeon(int fnt){ //繪製地下城
    background(BLACK);
    for(int y = -4;y < 6;y++){
        for(int x = -5;x < 6;x++){
            Xpos = (x+5)*80;
            Ypos = (y+4)*80;
            dx = pl_x + x;
            dy = pl_y + y;
            if(0 <= dx && dx < DUNGEON_W && 0 <= dy && dy < DUNGEON_H){
                if(dungeon[dy][dx] <= 3){
                    image(imgFloor[dungeon[dy][dx]], Xpos, Ypos);
                }
                if(dungeon[dy][dx] == 9){
                    image(imgWall, Xpos, Ypos-40);
                    if(dy >= 1 && dungeon[dy-1][dx] == 9){
                        image(imgWall2, Xpos, Ypos-80);
                    }
                }
            }
            if(x == 0 && y == 0){ //顯示主角
                image(imgPlayer[pl_a], Xpos, Ypos-40);
            }
        }
    }
    image(imgDark, 0, 0); //在四個角落配置暗沉的圖片
    draw_para(fnt); //顯示主角的能力
}

void put_event(){
    //配置樓梯
    while(true){
        x = int(random(3, DUNGEON_W-2));
        y = int(random(3, DUNGEON_H-2));
        if(dungeon[y][x] == 0){
            for(int ry = -1;ry < 2;ry++){ //將樓梯周圍的空間設定為地板
                for(int rx = -1;rx < 2;rx++){
                    dungeon[y+ry][x+rx] = 0;
                }
            }
            dungeon[y][x] = 3;
            break;
        }
    }
    //配置寶箱與繭
    for(int i = 0;i < 60;i++){
        x = int(random(3, DUNGEON_W-2));
        y = int(random(3, DUNGEON_H-2));
        if(dungeon[y][x] == 0){
            int dun = int(random(1, 7));
            if(dun == 1){
                dungeon[y][x] = 1;
            }
            else{
                dungeon[y][x] = 2;
            }
        }
    }
    //玩家的初始位置
    while(true){
        pl_x = int(random(3, DUNGEON_W-2));
        pl_y = int(random(3, DUNGEON_H-2));
        if(dungeon[pl_y][pl_x] == 0){
            break;
        }
    }
    pl_d = 1;
    pl_a = 2;
}

void move_player(){ //主角的移動
    if(dungeon[pl_y][pl_x] == 1){ //走到寶箱的位置
        dungeon[pl_y][pl_x] = 0;
        treasure = int(random(0, 11));
        if(treasure <= 2){
            treasure = 0;
        }
        else{
          if(treasure <= 8){
              treasure = 1;
          }
          else{
              treasure = 2;
          }
        }
        if(treasure == 0){
            potion++;
        }
        if(treasure == 1){
            blazegem++;
        }
        if(treasure == 2){
            food = int(food/2);
        }
        idx = 3;
        tmr = 0;
        return;
    }
    if(dungeon[pl_y][pl_x] == 2){ //走到繭的位置
        dungeon[pl_y][pl_x] = 0;
        r = int(random(0, 101));
        if(r < 40){ //食物
            treasure = int(random(0, 5));
            if(treasure <= 2){
                treasure = 3;
            }
            else{
                treasure = 4;
            }
            if(treasure == 3) food = food + 20;
            if(treasure == 4) food = food + 100;
            idx = 3;
            tmr = 0;
        }
        else{ //敵人出現
            idx = 10;
            tmr = 0;
        }
        return;
    }
    if(dungeon[pl_y][pl_x] == 3){ //走到樓梯的位置
        idx = 2;
        tmr = 0;
        return;
    }

    //以方向鍵上下左右移動
    x = pl_x;
    y = pl_y;
    if(keyPressed){
        if(keyCode == UP||key == 'w'){
            pl_d = 0;
            if(dungeon[pl_y-1][pl_x] != 9){
                pl_y--;
            }
        }
        if(keyCode == DOWN||key == 's'){
            pl_d = 1;
            if(dungeon[pl_y+1][pl_x] != 9){
                pl_y++;
            }
        }
        if(keyCode == LEFT||key == 'a'){
            pl_d = 2;
            if(dungeon[pl_y][pl_x-1] != 9){
                pl_x--;
            }
        }
        if(keyCode == RIGHT||key == 'd'){
            pl_d = 3;
            if(dungeon[pl_y][pl_x+1] != 9){
                pl_x++;
            }
        }
    }
    pl_a = pl_d*2;
    if(pl_x != x || pl_y != y){ //移動時，計算食物的存量與體力
        pl_a = pl_a + tmr%2; //移動時的原地踏步動畫
        if(food > 0){
            food--;
            if(pl_life < pl_lifemax){
                pl_life++;
            }
        }
        else{
            pl_life = pl_life - 5;
            if(pl_life <= 0){
                pl_life = 0;
                minim.stop();
                idx = 9;
                tmr = 0;
            }
        }
    }
}

void draw_para(int fnt){ //顯示主角的能力
    Xpos = 30;
    Ypos = 600;
    image(imgPara, Xpos, Ypos);
    col = WHITE;
    if(pl_life < 10 && tmr%2 == 0) col = RED;
    if(fnt == 0){
        textFont(font);
    }
    else{
        if(fnt == 1){
            textFont(fontS);
        }
    }
    fill(col);
    text(str(pl_life) + "/" + str(pl_lifemax), Xpos+128, Ypos+25);
    fill(WHITE);
    text(str(pl_str), Xpos+128, Ypos+53);
    col = WHITE;
    if(food == 0 && tmr%2 == 0) col = RED;
    fill(col);
    text(str(food), Xpos+128, Ypos+6+75);
    fill(WHITE);
    text(str(potion), Xpos+266, Ypos+26);
    text(str(blazegem), Xpos+266, Ypos+53);
}

void mousePressed() {
  switch (stage){
    case 1:
      subtractGame.mousePressed();
      break;
    case 2:
      multiplyGame.mousePressed();
      break;
    case 3:
      divideGame.mousePressed();
      break;
    case 4:
      divisibleGame.mousePressed();
      break;     
  }

}

void mouseDragged() {
  if (stage == 2) {
    multiplyGame.mouseDragged(); // 呼叫 multiplyGame 的 mouseDragged()
  }
}

void mouseReleased() {
    switch (stage){
    case 1:
      subtractGame.mouseReleased();
      break;
    case 2:
      multiplyGame.mouseReleased();
      break;
    case 3:
      divideGame.mouseReleased();
      break; 
  }
}

void drawMainMenu() {
  pushStyle();
  fill(0);
  textAlign(CENTER);
  textSize(36);
  text("主選單", width / 2 , 150);
  
  
  textSize(24);
  fill(200);
  rect(340, 280, 200, 60);
  fill(0);
  text("開始遊戲", width/2, 315);
  
  fill(200);
  rect(340, 380, 200, 60);
  fill(0);
  text("Help", width / 2, 415);
  
  fill(200);
  rect(340, 480, 200, 60);
  fill(0);
  text("About Us", width / 2, 515);
  popStyle(); 
}
