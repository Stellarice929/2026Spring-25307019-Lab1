import router from '@ohos.router';
import preferences from '@ohos.data.preferences'; // 新增这行
// 类型定义必须放在struct外面
interface CakeItem {
  id: number
  name: string
  picName: string
  needFlour: number
  needEgg: number
  needCocoa: number
  unlock: boolean
  scoreReward: number
}

@Entry
@Component
struct CocoBakeryDraw {
  // ============ 核心游戏数据 全部补全声明 ============
  @State cocoPowder: number = 20  // 初始0
  @State drawChance: number = 0
  @State hasGotReward: boolean = false // 新增：防止重复领取可可粉

  @State flour: number = 0
  @State egg: number = 0
  @State chocolate: number = 0
  @State totalScore: number = 0

  readonly costExchange: number = 10

  // 抽奖临时奖励
  @State isDrawing: boolean = false
  @State showResultPopup: boolean = false
  @State resultText: string = ""
  @State getFlour: number = 0
  @State getEgg: number = 0
  @State getChoco: number = 0
  // 烘焙工坊弹窗开关
  @State showBakeShopPopup: boolean = false

  @State cakeList: CakeItem[] = [
    {id:1, name:"甜蜜华夫饼", picName:"cake1", needFlour:3, needEgg:2, needCocoa:1, unlock:false, scoreReward:20},
    {id:2, name:"元气满满面", picName:"cake2", needFlour:4, needEgg:1, needCocoa:0, unlock:false, scoreReward:25},
    {id:3, name:"心动蛋包饭", picName:"cake3", needFlour:2, needEgg:3, needCocoa:1, unlock:false, scoreReward:30},
    {id:4, name:"快乐串串烧", picName:"cake4", needFlour:5, needEgg:2, needCocoa:2, unlock:false, scoreReward:35},
  ]

  build() {
    Stack() {
      // 1.全局背景
      Column()
        .width('100%')
        .height('100%')
        .backgroundImage($r('app.media.coco_main_bg'))
        .backgroundImageSize(ImageSize.Cover)

      // 2.上层UI布局
      Column() {
        Blank().layoutWeight(1.2)

        // 道具展示区
        Row({space:40}) {
          Column() {
            Text(`面粉`)
              .fontSize(16)
              .fontColor('#5A381E')
            Text(`×${this.flour}`)
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#8B4513')
          }
          Column() {
            Text(`鸡蛋`)
              .fontSize(16)
              .fontColor('#5A381E')
            Text(`×${this.egg}`)
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#8B4513')
          }
          Column() {
            Text(`巧克力`)
              .fontSize(16)
              .fontColor('#5A381E')
            Text(`×${this.chocolate}`)
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#8B4513')
          }
        }
        .padding(20)
        .backgroundColor('rgba(255,255,255,0.75)')
        .borderRadius(18)

        Blank().layoutWeight(1)

        Text(`剩余摇一摇机会：${this.drawChance}次`)
          .fontSize(17)
          .margin({bottom:15})
          .fontColor('#442c1a')

        // 底部双按钮
        Row({space:15}) {
          Button(this.isDrawing ? "抽奖摇动中..." : "摇一摇 得碎片")
            .width('65%')
            .height(70)
            .fontSize(22)
            .borderRadius(35)
            .backgroundColor('#7A482B')
            .fontColor('#fff')
            .enabled(!this.isDrawing && this.drawChance > 0)
            .onClick(()=>{
              this.startDraw()
            })

          Button("兑换\n机会")
            .width('30%')
            .height(70)
            .fontSize(17)
            .borderRadius(20)
            .backgroundColor('#9B5E38')
            .fontColor('#fff')
            .onClick(()=>{
              this.exchangeChance()
            })
        }

        Text(`当前可可粉：${this.cocoPowder}  | 兑换1次消耗${this.costExchange}可可粉`)
          .fontSize(14)
          .margin({top:12, bottom:8})
          .opacity(0.8)

        Blank().height(16)
        Button("🍬 食材翻牌消消乐")
          .width('90%')
          .height(60)
          .fontSize(18)
          .backgroundColor('#72462c')
          .fontColor('#fff')
          .onClick(() => {
            try {
              router.pushUrl({ url: "pages/MatchGame/MatchGame" })
            } catch (err) {
              console.error("跳转消消乐失败", err);
            }
          })

        Button("🍰 烘焙工坊（查看全部甜点配方）")
          .width('90%')
          .height(60)
          .fontSize(18)
          .borderRadius(30)
          .backgroundColor('#72462c')
          .fontColor('#fff')
          .onClick(()=>{
            this.showBakeShopPopup = true
          })
        Blank().height(20)
      }
      .width('100%')
      .height('100%')
      .padding({left:15, right:15})

      // 抽奖弹窗
      if(this.showResultPopup) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('rgba(0,0,0,0.55)')
        Column({space:25}) {
          Text(this.resultText)
            .fontSize(26)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .fontColor('#5A381E')
          Row({space:25}) {
            if(this.getFlour>0) {
              Column(){Text("🫓面粉").fontSize(20);Text(`+${this.getFlour}`)}
            }
            if(this.getEgg>0) {
              Column(){Text("🥚鸡蛋").fontSize(20);Text(`+${this.getEgg}`)}
            }
            if(this.getChoco>0) {
              Column(){Text("🍫巧克力").fontSize(20);Text(`+${this.getChoco}`)}
            }
          }
          Button("开心收下")
            .width(200)
            .height(55)
            .borderRadius(30)
            .backgroundColor('#9B5E38')
            .fontColor('#fff')
            .onClick(()=>{
              this.closePopup()
            })
        }
        .width('82%')
        .padding({top:35,bottom:35,left:35,right:35})
        .backgroundColor('#fff9f2')
        .borderRadius(25)
        .shadow({radius:20})
      }

      // 烘焙工坊弹窗
      if(this.showBakeShopPopup){
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('rgba(0,0,0,0.55)')
        Column({space:16}){
          Text("🍰 烘焙工坊 · 全部甜点配方")
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor("#5A381E")
          List({space:14}){
            ForEach(this.cakeList, (item:CakeItem)=>{
              ListItem(){
                Row({space:12}){
                  Image($r(`app.media.${item.picName}`))
                    .width(80)
                    .height(80)
                    .borderRadius(12)
                    .opacity(item.unlock ? 1 : 0.45)
                  Column(){
                    Text(item.name).fontSize(19).fontWeight(FontWeight.Medium)
                    Text(`配方：面粉${item.needFlour} 鸡蛋${item.needEgg} 可可${item.needCocoa}`)
                      .fontSize(14).margin({top:4})
                    Text(item.unlock ? "✅ 已解锁" : "🔒 未合成")
                      .fontSize(13)
                      .fontColor(item.unlock ? "#2E7D32" : "#999")
                  }
                  Blank()
                  Button("合成")
                    .width(90)
                    .height(42)
                    .fontSize(15)
                    .borderRadius(20)
                    .backgroundColor('#805030')
                    .fontColor('#fff')
                    .enabled(this.flour >= item.needFlour && this.egg >= item.needEgg && this.chocolate >= item.needCocoa)
                    .onClick(()=>{
                      this.makeCake(item)
                    })
                }
                .width('100%')
                .padding(12)
                .backgroundColor('#fff9f2')
                .borderRadius(16)
              }
            })
          }
          .width('100%')
          .height('100%')
          .layoutWeight(1)
          Button("关闭工坊")
            .width(200)
            .height(52)
            .borderRadius(28)
            .backgroundColor("#633c26")
            .fontColor("#fff")
            .onClick(()=>{
              this.showBakeShopPopup = false
            })
        }
        .width('88%')
        .height('80%')
        .padding(24)
        .backgroundColor('#fff9f2')
        .borderRadius(28)
        .shadow({radius:22})
      }
    }
    .width('100%')
    .height('100%')
  }

  // 兑换机会
  exchangeChance(){
    if(this.cocoPowder >= this.costExchange){
      this.cocoPowder -= this.costExchange
      this.drawChance += 1
      AlertDialog.show({message:"兑换成功！获得1次摇一摇机会✨"})
    }else{
      AlertDialog.show({message:"可可粉不足，无法兑换！"})
    }
  }

  // 抽奖逻辑
  startDraw(){
    if(this.drawChance <=0 || this.isDrawing) return
    this.isDrawing = true
    this.drawChance -= 1
    this.getFlour = 0
    this.getEgg = 0
    this.getChoco = 0
    let random = Math.random()
    if(random < 0.25){
      this.resultText = "不要放弃，再摇一次\n说不定有新碎片~"
    }else if(random < 0.5){
      this.getFlour =1
      this.resultText = "✨找到碎片啦！"
    }else if(random < 0.75){
      this.getFlour =1
      this.getEgg =1
      this.resultText = "✨找到碎片啦！"
    }else if(random < 0.92){
      this.getFlour =1
      this.getChoco =1
      this.resultText = "✨找到碎片啦！"
    }else{
      this.getFlour =1
      this.getEgg =1
      this.getChoco =1
      this.resultText = "🎉大丰收！全部碎片到手！"
    }
    setTimeout(()=>{
      this.flour += this.getFlour
      this.egg += this.getEgg
      this.chocolate += this.getChoco
      this.isDrawing = false
      this.showResultPopup = true
    },2200)
  }

  closePopup(){
    this.showResultPopup = false
  }

  // 合成甜点
  makeCake(item:CakeItem){
    this.flour -= item.needFlour
    this.egg -= item.needEgg
    this.chocolate -= item.needCocoa
    item.unlock = true
    this.totalScore += item.scoreReward
    AlertDialog.show({message:`🎉 成功制作【${item.name}】！积分+${item.scoreReward}`})
  }

  // 页面返回接收消消乐可可粉（已删除clearParams，无报错）
  aboutToAppear() {
    let params = router.getParams() as Record<string, number>;
    if (params?.addCocoNum) {
      this.cocoPowder += params.addCocoNum;
      console.info("成功增加可可粉："+params.addCocoNum);
    }
  }
}