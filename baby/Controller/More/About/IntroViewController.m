//
//  IntroViewController.m
//  baby
//
//  Created by zhang da on 14-5-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "IntroViewController.h"
#import "UIButtonExtra.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (void)dealloc {
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [Shared bbRealWhite];

        UITextView *detail = [[UITextView alloc] initWithFrame:
                              CGRectMake(10, 50, 300, screentContentHeight - 50)];
        detail.font = [UIFont systemFontOfSize:15];
        detail.backgroundColor = [UIColor clearColor];
        detail.alwaysBounceVertical = YES;
        detail.editable = NO;
        detail.textColor = [UIColor grayColor];
        detail.showsVerticalScrollIndicator = NO;
        [self.view addSubview:detail];
        [detail release];
        
        UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [bbTopbar addSubview:back];
        
        detail.text = @"       中国儿童原创绘本第一连锁品牌，致力于儿童美术领域研究，秉持“通过画画，还原孩子想象力”这一宗旨，针对3-7岁儿童首创“变变变”思维儿童美术教学体系；针对7-15岁儿童首创“绘本美术”教学体系；建立了“宝贝计画冰山理论”系统。成立四年来，已有4000多名小朋友在此学习画画，得到近万名家长的支持和信任。央视、北京卫视对于宝贝计画专题报道。台湾著名绘本作家“几米”先生对于宝贝计画原创绘本孙得伦《快乐的椅子》赞誉有加，著名电视节目《爸爸去哪儿》张天天等小明星也在宝贝计画学习画画，截止2014年1月，在全国已有20家分中心，先后积累绘画作品近20万张，位于北京朝阳区东三环的“宝贝计画儿童原创绘本博物馆”馆藏孩子原创绘本近千册。宝贝计画坚定的认为：针对现在的教育现状，素质教育一定是未来的方向。宝贝计画就是为中国的素质教育在儿童美术这块进行大胆实践，走出新方向，丰富教育大环境。 从而，根据“家长为了孩子”这一需求，建设以大量会员基数的“平台”，通过提供“以画画为载体”，以专业的教学，启发孩子想象力等综合素质，打造中国儿童原创绘本，为中国素质教育发展探索新思路。";
    }
    return self;
}

- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewTitle:@"简介"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
