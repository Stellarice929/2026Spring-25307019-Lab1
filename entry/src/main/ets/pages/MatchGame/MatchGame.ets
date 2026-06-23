import router from '@ohos.router';
import preferences from '@ohos.data.preferences'; // 新增这行
interface CardItem {
  id: number;
  picName: string;
  isOpen: boolean;
  isMatch: boolean;
}

@Entry
@Component
struct MatchGame {
  @State addCocoNum: number = 30
  @State cardList: CardItem[] = []
  @State openCards: CardItem[] = []
  @State isLock: boolean = false
  @State matchCount: number = 0
  totalPair: number = 6

  aboutToAppear() {
    this.initCardData()
  }

  initCardData() {
    let temp: CardItem[] = [
      { id: 1, picName: "candy", isOpen: false, isMatch: false },
      { id: 2, picName: "cocoa", isOpen: false, isMatch: false },
      { id: 3, picName: "cookie", isOpen: false, isMatch: false },
      { id: 4, picName: "egg", isOpen: false, isMatch: false },
      { id: 5, picName: "flour", isOpen: false, isMatch: false },
      { id: 6, picName: "syrup", isOpen: false, isMatch: false },
      { id: 1, picName: "candy", isOpen: false, isMatch: false },
      { id: 2, picName: "cocoa", isOpen: false, isMatch: false },
      { id: 3, picName: "cookie", isOpen: false, isMatch: false },
      { id: 4, picName: "egg", isOpen: false, isMatch: false },
      { id: 5, picName: "flour", isOpen: false, isMatch: false },
      { id: 6, picName: "syrup", isOpen: false, isMatch: false },
    ];
    // 打乱数组
    for (let i = temp.length - 1; i > 0; i--) {
      let j = Math.floor(Math.random() * (i + 1));
      let t = temp[i];
      temp[i] = temp[j];
      temp[j] = t;
    }
    this.cardList = temp;
    this.matchCount = 0;
    this.openCards = [];
    this.isLock = false;
  }

  // 纯下标修改，不使用...扩展运算符
  clickCard(index: number) {
    let target = this.cardList[index];
    if (this.isLock || target.isOpen || target.isMatch) {
      return;
    }
    // 直接修改原数组属性，重新赋值数组触发UI刷新
    this.cardList[index].isOpen = true;
    let copyArr: CardItem[] = [];
    for (let i = 0; i < this.cardList.length; i++) {
      copyArr.push(this.cardList[i]);
    }
    this.cardList = copyArr;
    this.openCards.push(target);

    if (this.openCards.length === 2) {
      this.isLock = true;
      let c1 = this.openCards[0];
      let c2 = this.openCards[1];
      if (c1.id === c2.id) {
        // 配对成功锁定
        for (let i = 0; i < this.cardList.length; i++) {
          if (this.cardList[i].id === c1.id) {
            this.cardList[i].isMatch = true;
          }
        }
        let newArr: CardItem[] = [];
        for (let i = 0; i < this.cardList.length; i++) {
          newArr.push(this.cardList[i]);
        }
        this.cardList = newArr;
        this.matchCount += 1;
        this.openCards = [];
        this.isLock = false;
      } else {
        // 配对失败延时翻回
        setTimeout(() => {
          for (let i = 0; i < this.cardList.length; i++) {
            if (this.cardList[i] === c1 || this.cardList[i] === c2) {
              this.cardList[i].isOpen = false;
            }
          }
          let resetArr: CardItem[] = [];
          for (let i = 0; i < this.cardList.length; i++) {
            resetArr.push(this.cardList[i]);
          }
          this.cardList = resetArr;
          this.openCards = [];
          this.isLock = false;
        }, 800);
      }
    }
  }

  build() {
    Column() {
      Text("食材翻牌消消乐")
        .fontSize(30)
        .margin({ bottom: 10 })

      Text(`已配对：${this.matchCount}/${this.totalPair}｜通关奖励：${this.addCocoNum}可可粉`)
        .fontSize(18)
        .margin({ bottom: 20 })

      Column({ space: 12 }) {
        // 第一行
        Row({ space: 8 }) {
          Stack() {
            if (!this.cardList[0].isOpen && !this.cardList[0].isMatch) {
              Image($r(`app.media.card_back`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
            } else {
              Image($r(`app.media.${this.cardList[0].picName}`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
              if (this.cardList[0].isMatch) {
                Text("✓")
                  .fontSize(28)
                  .fontColor(Color.Green)
                  .position({ x: 65, y: 0 })
              }
            }
          }
          .width(72)
          .height(92)
          .onClick(() => this.clickCard(0))

          Stack() {
            if (!this.cardList[1].isOpen && !this.cardList[1].isMatch) {
              Image($r(`app.media.card_back`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
            } else {
              Image($r(`app.media.${this.cardList[1].picName}`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
              if (this.cardList[1].isMatch) {
                Text("✓")
                  .fontSize(28)
                  .fontColor(Color.Green)
                  .position({ x: 65, y: 0 })
              }
            }
          }
          .width(72)
          .height(92)
          .onClick(() => this.clickCard(1))

          Stack() {
            if (!this.cardList[2].isOpen && !this.cardList[2].isMatch) {
              Image($r(`app.media.card_back`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
            } else {
              Image($r(`app.media.${this.cardList[2].picName}`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
              if (this.cardList[2].isMatch) {
                Text("✓")
                  .fontSize(28)
                  .fontColor(Color.Green)
                  .position({ x: 65, y: 0 })
              }
            }
          }
          .width(72)
          .height(92)
          .onClick(() => this.clickCard(2))

          Stack() {
            if (!this.cardList[3].isOpen && !this.cardList[3].isMatch) {
              Image($r(`app.media.card_back`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
            } else {
              Image($r(`app.media.${this.cardList[3].picName}`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
              if (this.cardList[3].isMatch) {
                Text("✓")
                  .fontSize(28)
                  .fontColor(Color.Green)
                  .position({ x: 65, y: 0 })
              }
            }
          }
          .width(72)
          .height(92)
          .onClick(() => this.clickCard(3))
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)

        // 第二行
        Row({ space: 8 }) {
          Stack() {
            if (!this.cardList[4].isOpen && !this.cardList[4].isMatch) {
              Image($r(`app.media.card_back`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
            } else {
              Image($r(`app.media.${this.cardList[4].picName}`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
              if (this.cardList[4].isMatch) {
                Text("✓")
                  .fontSize(28)
                  .fontColor(Color.Green)
                  .position({ x: 65, y: 0 })
              }
            }
          }
          .width(72)
          .height(92)
          .onClick(() => this.clickCard(4))

          Stack() {
            if (!this.cardList[5].isOpen && !this.cardList[5].isMatch) {
              Image($r(`app.media.card_back`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
            } else {
              Image($r(`app.media.${this.cardList[5].picName}`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
              if (this.cardList[5].isMatch) {
                Text("✓")
                  .fontSize(28)
                  .fontColor(Color.Green)
                  .position({ x: 65, y: 0 })
              }
            }
          }
          .width(72)
          .height(92)
          .onClick(() => this.clickCard(5))

          Stack() {
            if (!this.cardList[6].isOpen && !this.cardList[6].isMatch) {
              Image($r(`app.media.card_back`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
            } else {
              Image($r(`app.media.${this.cardList[6].picName}`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
              if (this.cardList[6].isMatch) {
                Text("✓")
                  .fontSize(28)
                  .fontColor(Color.Green)
                  .position({ x: 65, y: 0 })
              }
            }
          }
          .width(72)
          .height(92)
          .onClick(() => this.clickCard(6))

          Stack() {
            if (!this.cardList[7].isOpen && !this.cardList[7].isMatch) {
              Image($r(`app.media.card_back`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
            } else {
              Image($r(`app.media.${this.cardList[7].picName}`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
              if (this.cardList[7].isMatch) {
                Text("✓")
                  .fontSize(28)
                  .fontColor(Color.Green)
                  .position({ x: 65, y: 0 })
              }
            }
          }
          .width(72)
          .height(92)
          .onClick(() => this.clickCard(7))
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)

        // 第三行
        Row({ space: 8 }) {
          Stack() {
            if (!this.cardList[8].isOpen && !this.cardList[8].isMatch) {
              Image($r(`app.media.card_back`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
            } else {
              Image($r(`app.media.${this.cardList[8].picName}`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
              if (this.cardList[8].isMatch) {
                Text("✓")
                  .fontSize(28)
                  .fontColor(Color.Green)
                  .position({ x: 65, y: 0 })
              }
            }
          }
          .width(72)
          .height(92)
          .onClick(() => this.clickCard(8))

          Stack() {
            if (!this.cardList[9].isOpen && !this.cardList[9].isMatch) {
              Image($r(`app.media.card_back`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
            } else {
              Image($r(`app.media.${this.cardList[9].picName}`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
              if (this.cardList[9].isMatch) {
                Text("✓")
                  .fontSize(28)
                  .fontColor(Color.Green)
                  .position({ x: 65, y: 0 })
              }
            }
          }
          .width(72)
          .height(92)
          .onClick(() => this.clickCard(9))

          Stack() {
            if (!this.cardList[10].isOpen && !this.cardList[10].isMatch) {
              Image($r(`app.media.card_back`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
            } else {
              Image($r(`app.media.${this.cardList[10].picName}`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
              if (this.cardList[10].isMatch) {
                Text("✓")
                  .fontSize(28)
                  .fontColor(Color.Green)
                  .position({ x: 65, y: 0 })
              }
            }
          }
          .width(72)
          .height(92)
          .onClick(() => this.clickCard(10))

          Stack() {
            if (!this.cardList[11].isOpen && !this.cardList[11].isMatch) {
              Image($r(`app.media.card_back`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
            } else {
              Image($r(`app.media.${this.cardList[11].picName}`))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
              if (this.cardList[11].isMatch) {
                Text("✓")
                  .fontSize(28)
                  .fontColor(Color.Green)
                  .position({ x: 65, y: 0 })
              }
            }
          }
          .width(72)
          .height(92)
          .onClick(() => this.clickCard(11))
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }
      .layoutWeight(1)
      .margin({ bottom: 24 })

      Button("完成闯关，返回烘焙主页")
        .width('82%')
        .height(62)
        .fontSize(20)
        .backgroundColor('#7A482B')
        .fontColor('#fff')
        .enabled(this.matchCount >= this.totalPair)
        .onClick(() => {
          try {
            // 跳转首页，携带奖励数字
            router.pushUrl({
              url: "pages/index/index",
              params: {
                addCocoNum: 30
              }
            })
            // 关闭消消乐页面，回到首页
            setTimeout(()=>{
              router.back()
            },100)
          } catch (err) {
            console.error("跳转失败", err)
          }
        })
      Text("集齐全部6组食材卡片后，方可领取奖励返回")
        .fontSize(14)
        .fontColor('#999')
        .margin({ top: 8 })
    }
    .width('100%')
    .height('100%')
    .padding(12)
  }
}