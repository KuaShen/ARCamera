//
//  CAViewController.m
//  ARCamera
//
//  Created by KuaShen on 03/28/2019.
//  Copyright (c) 2019 KuaShen. All rights reserved.
//

#import "CAViewController.h"
#import <ARKit/ARKit.h>
#import "CAEffectsCell.h"
#import "CAMessageView.h"

#define SCREEN_W ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_H ([[UIScreen mainScreen] bounds].size.height)
#define PARTICLEBUNDLE @"CameraScene.scnassets/SystemParticle/"
#define MODELBUNDLE @"CameraScene.scnassets/Scenes/"
#define BUTTONWIDTH 40

API_AVAILABLE(ios(11.0))
@interface CAViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    SCNParticleSystem *particleSystem;
    BOOL isShowEffect;
    BOOL isShowModel;
    UIButton *modelBtn;
    UIButton *effectBtn;
    SCNScene *spaceScene;
    SCNNode *raccoonNode;
    
    UIButton *walk;
    UIButton *idle;
    UIButton *jump;
    UIButton *spin;
    UIButton *cancel;
}

@property (nonatomic, strong) ARSCNView *sceneView;

@property (nonatomic, strong) ARSession *session;

@property (nonatomic, strong) ARWorldTrackingConfiguration *trackConfig;

@property (nonatomic, strong) UICollectionView *scrollPickerView;
@property (nonatomic, strong) UICollectionView *modelPickerView;
@property (nonatomic, strong) UIButton *showEffectBtn;
@property (nonatomic, strong) UIView *chooseView;
@property (nonatomic, strong) UIButton *takePhotoBtn;

@property (nonatomic, strong) NSArray *effectImageArray;
@property (nonatomic, strong) NSArray *effectTitleArray;
@property (nonatomic, strong) NSArray *effectPathArray;

@property (nonatomic, strong) NSArray *modelImageArray;
@property (nonatomic, strong) NSArray *modelTitleArray;
@property (nonatomic, strong) NSArray *modelPathArray;


@end

@implementation CAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    spaceScene = self.sceneView.scene;
	
    [self startAR];
    [self setData];
    [self setUI];
//    [self loadSystemPraticle:[NSString stringWithFormat:@"%@Rain.scnp",PARTICLEBUNDLE]];
}

- (void)startAR{
    
    self.view = self.sceneView;
//    _sceneView.delegate = self;
    _sceneView.session = self.session;
    
}

- (void)setUI{
    
    [self.sceneView addSubview:self.scrollPickerView];
    [self.sceneView addSubview:self.modelPickerView];
    [self.sceneView addSubview:self.showEffectBtn];
    [self.sceneView addSubview:self.takePhotoBtn];
    
}

- (void)setData{
    
    isShowEffect = NO;
    isShowModel = NO;
    
    _effectImageArray = @[@"rain",@"bokeh",@"star",@"fire",@"smoke",@"confetti"];
    _effectTitleArray = @[@"Rain",@"Bubble",@"Starry",@"Fire",@"Smoke",@"Confetti"];
    _effectPathArray  = @[@"Rain.scnp",@"Bokeh.scnp",@"Stars.scnp",@"Fire.scnp",@"Smoke.scnp",@"Confetti.scnp"];
    
    _modelImageArray = @[@"raccoon"];
    _modelTitleArray = @[@"Raccoon"];
    _modelPathArray  = @[@"max.scn"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [_session runWithConfiguration:self.trackConfig options:nil];
    
}

- (void)loadSystemPraticle:(NSString *)name{
    
    particleSystem = [SCNParticleSystem particleSystemNamed:[NSString stringWithFormat:@"%@%@",PARTICLEBUNDLE,name] inDirectory:nil];
//    SCNNode *node = [SCNNode node];
//    [node addParticleSystem:particleSystem];
//    node.position = SCNVector3Make(0, -1, 0);
    
    [_sceneView.scene.rootNode addParticleSystem:particleSystem];
    
}

- (void)loadModel:(NSString *)modelName{
    SCNScene *scene = [SCNScene sceneNamed:[NSString stringWithFormat:@"%@%@",MODELBUNDLE,modelName]];
    raccoonNode = scene.rootNode.childNodes[0];
    raccoonNode.position = SCNVector3Make(0, 0, -1);
    [self addModelActionButtons];
    self.sceneView.scene = scene;
    [self loadModelActions];
}

- (void)removeModel{
    self.sceneView.scene = spaceScene;
}

#pragma mark ------------ model Actions ---------------

- (void)addModelActionButtons{
    walk = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W - 40, 40, BUTTONWIDTH, BUTTONWIDTH)];
    [self clipCornerRadius:BUTTONWIDTH / 2 withView:walk];
    [walk setBackgroundImage:[UIImage imageNamed:@"walk"] forState:(UIControlStateNormal)];
    [walk addTarget:self action:@selector(walk) forControlEvents:UIControlEventTouchUpInside];
    [self.sceneView addSubview:walk];
    
    idle = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W - 40, 130, BUTTONWIDTH, BUTTONWIDTH)];
    [self clipCornerRadius:BUTTONWIDTH / 2 withView:idle];
    [idle setBackgroundImage:[UIImage imageNamed:@"stand"] forState:(UIControlStateNormal)];
    [idle addTarget:self action:@selector(idle) forControlEvents:UIControlEventTouchUpInside];
    [self.sceneView addSubview:idle];
    
    jump = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W - 40, 220, BUTTONWIDTH, BUTTONWIDTH)];
    [self clipCornerRadius:BUTTONWIDTH / 2 withView:jump];
    [jump setBackgroundImage:[UIImage imageNamed:@"jump"] forState:(UIControlStateNormal)];
    [jump addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [self.sceneView addSubview:jump];
    
    spin = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W - 40, 310, BUTTONWIDTH, BUTTONWIDTH)];
    [self clipCornerRadius:BUTTONWIDTH / 2 withView:spin];
    [spin setBackgroundImage:[UIImage imageNamed:@"spin"] forState:(UIControlStateNormal)];
    [spin addTarget:self action:@selector(spin) forControlEvents:UIControlEventTouchUpInside];
    [self.sceneView addSubview:spin];
    
    cancel = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W - 40, SCREEN_H - 40, BUTTONWIDTH, BUTTONWIDTH)];
    [self clipCornerRadius:BUTTONWIDTH / 2 withView:cancel];
    [cancel setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.sceneView addSubview:cancel];
}

- (void)setActionButtonsHidden:(BOOL)isHidden{
    walk.hidden = isHidden;
    idle.hidden = isHidden;
    jump.hidden = isHidden;
    spin.hidden = isHidden;
    cancel.hidden = isHidden;
}

- (void)walk{
    [self stopAllActions];
    [[raccoonNode animationPlayerForKey:@"walk"] play];
    NSLog(@"walk!!!");
}

- (void)idle{
    [self stopAllActions];
    [[raccoonNode animationPlayerForKey:@"idle"] play];
    NSLog(@"idle!!!");
}

- (void)jump{
    [self stopAllActions];
    SCNAnimationPlayer *jump = [self loadAnimationFromSceneNamed:[NSString stringWithFormat:@"%@max_jump.scn",MODELBUNDLE]];
    [raccoonNode addAnimationPlayer:jump forKey:@"jump"];
    [jump play];
    [[raccoonNode animationPlayerForKey:@"jump"] play];
    NSLog(@"jump!!!");
}

- (void)spin {
    [self stopAllActions];

    SCNAnimationPlayer *spin = [self loadAnimationFromSceneNamed:[NSString stringWithFormat:@"%@max_spin.scn",MODELBUNDLE]];
    [raccoonNode addAnimationPlayer:spin forKey:@"spin"];
    [spin play];
    NSLog(@"spin!!!");
    
}


- (void)stopAllActions{
    for (NSString *key in raccoonNode.animationKeys) {
        [[raccoonNode animationPlayerForKey:key] stop];
        NSLog(@"key==%@",key);
    }
}

- (void)cancel{
    [self setActionButtonsHidden:YES];
    [self removeModel];
}

- (void)loadModelActions API_AVAILABLE(ios(11.0)){
    SCNAnimationPlayer *walk = [self loadAnimationFromSceneNamed:[NSString stringWithFormat:@"%@max_walk.scn",MODELBUNDLE]];
    [raccoonNode addAnimationPlayer:walk forKey:@"walk"];
    [walk stop];
    
    SCNAnimationPlayer *idle = [self loadAnimationFromSceneNamed:[NSString stringWithFormat:@"%@max_idle.scn",MODELBUNDLE]];
    [raccoonNode addAnimationPlayer:idle forKey:@"idle"];
    [idle stop];
    
}


- (SCNAnimationPlayer *)loadAnimationFromSceneNamed:(NSString *)sceneName  API_AVAILABLE(ios(11.0)){
    SCNScene *scene = [SCNScene sceneNamed:sceneName];
    
    // find top level animation
    __block SCNAnimationPlayer *animationPlayer = nil;
    [scene.rootNode enumerateChildNodesUsingBlock:^(SCNNode *child, BOOL *stop) {
        if (child.animationKeys.count > 0) {
            animationPlayer = [child animationPlayerForKey:child.animationKeys[0]];
            *stop = YES;
        }
    }];
    
    return animationPlayer;
}

- (void)removePraticle{
    
    [_sceneView.scene.rootNode removeParticleSystem:particleSystem];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.chooseView removeFromSuperview];
}

#pragma mark ------------- button Action --------------

- (void)showEffect{
    _modelPickerView.hidden = YES;
    [self hideViewAnimateWithView:_modelPickerView];
    isShowModel = NO;
    
    _scrollPickerView.hidden = NO;
    if (!isShowEffect) {
        [self showViewAnimateWithView:_scrollPickerView];
        isShowEffect = YES;
        
    }else{
        [self hideViewAnimateWithView:_scrollPickerView];
        isShowEffect = NO;
    }
}

- (void)showModel{//显示，隐藏collectionView
    _scrollPickerView.hidden = YES;
    [self hideViewAnimateWithView:_scrollPickerView];
    isShowEffect = NO;
    
    _modelPickerView.hidden = NO;
    if (!isShowModel) {
        //        _scrollPickerView.hidden = NO;
        [self showViewAnimateWithView:_modelPickerView];
        isShowModel = YES;
        
    }else{
        [self hideViewAnimateWithView:_modelPickerView];
        isShowModel = NO;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            [self loadModelActions];
    });
}

- (void)showViewAnimateWithView:(UIView *)view{
    [UIView animateWithDuration:1.0 animations:^{
        if (_showEffectBtn.frame.origin.y + _showEffectBtn.frame.size.height + 85 > SCREEN_H) {//右侧
            view.frame = CGRectMake(0, _showEffectBtn.frame.origin.y - 85, SCREEN_W, 85);
        }else{
            view.frame = CGRectMake(0, _showEffectBtn.frame.origin.y + _showEffectBtn.frame.size.height, SCREEN_W, 85);
        }
        
    }];
}

- (void)hideViewAnimateWithView:(UIView *)view{
    [UIView animateWithDuration:1.0 animations:^{
        if (_showEffectBtn.frame.origin.y + _showEffectBtn.frame.size.height + 85 > SCREEN_H) {
            view.frame = CGRectMake(SCREEN_W, _showEffectBtn.frame.origin.y - 85, 0, 85);
        }else{
            view.frame = CGRectMake(0, _showEffectBtn.frame.origin.y + _showEffectBtn.frame.size.height, 0, 85);
        }
    }];
}

- (void)takePicture{
//    UIImage *image = [_sceneView snapshot];
    UIImageWriteToSavedPhotosAlbum([_sceneView snapshot], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)panAction:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:pan.view];
    pan.view.transform = CGAffineTransformTranslate(pan.view.transform, point.x, point.y);
    [pan setTranslation:CGPointZero inView:pan.view];
    
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    if (_showEffectBtn.frame.origin.x + _showEffectBtn.frame.size.width + 110 > SCREEN_W) {
        
        _chooseView.frame = CGRectMake(_showEffectBtn.frame.origin.x - 110, _showEffectBtn.frame.origin.y, 150, BUTTONWIDTH);
        modelBtn.frame = CGRectMake(0, 0, BUTTONWIDTH, BUTTONWIDTH);
        effectBtn.frame = CGRectMake(0 + BUTTONWIDTH + 15, 0, BUTTONWIDTH, BUTTONWIDTH);
        
    }else{
        _chooseView.frame = CGRectMake(_showEffectBtn.frame.origin.x, _showEffectBtn.frame.origin.y, 150, BUTTONWIDTH);
        modelBtn.frame = CGRectMake(BUTTONWIDTH + 15, 0, BUTTONWIDTH, BUTTONWIDTH);
        effectBtn.frame = CGRectMake((BUTTONWIDTH + 15) * 2, 0, BUTTONWIDTH, BUTTONWIDTH);
    }
    [self.sceneView addSubview:self.chooseView];
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
        [[CAMessageView sharedInstance] showNoteView:@"保存失败" subView:self.sceneView];
    }else{
        msg = @"保存图片成功" ;
        [[CAMessageView sharedInstance] showNoteView:@"保存成功" subView:self.sceneView];
    }
}


#pragma mark ------------- delegate --------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [collectionView isEqual:_scrollPickerView] ? _effectTitleArray.count : _modelTitleArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(60, 80);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if ([collectionView isEqual:_scrollPickerView]) {
        [self removePraticle];
        [self loadSystemPraticle:_effectPathArray[indexPath.item]];
    }else if ([collectionView isEqual:_modelPickerView]){
        //加载模型，动作按钮
        [self loadModel:@"max.scn"];
        [self setActionButtonsHidden:NO];
    }
    

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([collectionView isEqual:_scrollPickerView]) {
        [collectionView registerNib:[UINib nibWithNibName:@"CAEffectsCell" bundle:nil] forCellWithReuseIdentifier:@"CAEffectsCell"];
        CAEffectsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CAEffectsCell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_effectImageArray[indexPath.item]]];
        cell.title.text = _effectTitleArray[indexPath.item];
        
        return cell;
    }else if ([collectionView isEqual:_modelPickerView]){
        [collectionView registerNib:[UINib nibWithNibName:@"CAEffectsCell" bundle:nil] forCellWithReuseIdentifier:@"CAEffectsCell"];
        CAEffectsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CAEffectsCell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_modelImageArray[indexPath.item]]];
        cell.title.text = _modelTitleArray[indexPath.item];
        
        return cell;
    }
    
    return nil;
}


#pragma mark ------------- lazy load --------------

- (ARSCNView *)sceneView API_AVAILABLE(ios(11.0)){
    if (!_sceneView){
        if (@available(iOS 11.0, *)) {
            _sceneView = [[ARSCNView alloc] init];
            _sceneView.frame = self.view.bounds;
        }
        
    }
    
    
    return _sceneView;
}

- (ARSession *)session API_AVAILABLE(ios(11.0)){
    if (!_session){
        if (@available(iOS 11.0, *)) {
            _session = [[ARSession alloc] init];
        }
        
    }
    
    
    return _session;
}

- (ARWorldTrackingConfiguration *)trackConfig API_AVAILABLE(ios(11.0)){
    if (!_trackConfig) {
        //创建追踪
        if (@available(iOS 11.0, *)) {
            ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc]init];
            configuration.planeDetection = ARPlaneDetectionHorizontal;
            
            //自适应灯光(有强光到弱光会变的平滑一些)
            _trackConfig = configuration;
            _trackConfig.lightEstimationEnabled = true;
            
            [_session runWithConfiguration:configuration];
        }
        
    }
    
    return _trackConfig;
}

- (UICollectionView *)scrollPickerView{
    if (!_scrollPickerView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(3, 20, 0, 20);
        if (_showEffectBtn.frame.origin.y + _showEffectBtn.frame.size.height + 85 > SCREEN_H){//右侧
            _scrollPickerView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREEN_W, _showEffectBtn.frame.origin.y - 85, 0, 85) collectionViewLayout:flowLayout];
        }else{
            _scrollPickerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _showEffectBtn.frame.origin.y + _showEffectBtn.frame.size.height, 0, 85) collectionViewLayout:flowLayout];
        }
//        _scrollPickerView.hidden = YES;
        _scrollPickerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
        _scrollPickerView.delegate = self;
        _scrollPickerView.dataSource = self;
        
        
    }
    
    
    return _scrollPickerView;
}
- (UICollectionView *)modelPickerView{
    if (!_modelPickerView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(3, 20, 0, 20);
        if (_showEffectBtn.frame.origin.y + _showEffectBtn.frame.size.height + 85 > SCREEN_H){//右侧
            _modelPickerView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREEN_W, _showEffectBtn.frame.origin.y - 85, 0, 85) collectionViewLayout:flowLayout];
        }else{
            _modelPickerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _showEffectBtn.frame.origin.y + _showEffectBtn.frame.size.height, 0, 85) collectionViewLayout:flowLayout];
        }
        //        _scrollPickerView.hidden = YES;
        _modelPickerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
        _modelPickerView.delegate = self;
        _modelPickerView.dataSource = self;
        
        
    }
    
    
    return _modelPickerView;
}

- (UIButton *)showEffectBtn{
    if (!_showEffectBtn){
        _showEffectBtn = [[UIButton alloc] init];
        _showEffectBtn.frame = CGRectMake(0, SCREEN_H / 2, BUTTONWIDTH, BUTTONWIDTH);
        [self clipCornerRadius:BUTTONWIDTH / 2 withView:_showEffectBtn];
        [_showEffectBtn setImage:[UIImage imageNamed:@"scene"] forState:UIControlStateNormal];
        [_showEffectBtn addTarget:self action:@selector(showEffect)
                 forControlEvents:UIControlEventTouchUpInside];
        UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [_showEffectBtn addGestureRecognizer:pan];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        longPress.minimumPressDuration = 2.0;
        [_showEffectBtn addGestureRecognizer:longPress];
    }
    
    
    return _showEffectBtn;
}

- (UIButton *)takePhotoBtn{
    if (!_takePhotoBtn){
        _takePhotoBtn = [[UIButton alloc] init];
        _takePhotoBtn.frame = CGRectMake(SCREEN_W / 2 - 40, SCREEN_H - 100, 80, 80);
        [self clipCornerRadius:40 withView:_takePhotoBtn];
        [_takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [_takePhotoBtn addTarget:self action:@selector(takePicture)
                forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    return _takePhotoBtn;
}

- (UIView *)chooseView{
    if (!_chooseView){
        _chooseView = [[UIView alloc] init];
        _chooseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
        modelBtn = [[UIButton alloc]init];
        effectBtn = [[UIButton alloc]init];
        if (_showEffectBtn.frame.origin.x + _showEffectBtn.frame.size.width + 110 > SCREEN_W) {
            
            _chooseView.frame = CGRectMake(_showEffectBtn.frame.origin.x - 110, _showEffectBtn.frame.origin.y, 150, BUTTONWIDTH);
            modelBtn.frame = CGRectMake(0, 0, BUTTONWIDTH, BUTTONWIDTH);
            effectBtn.frame = CGRectMake(0 + BUTTONWIDTH + 15, 0, BUTTONWIDTH, BUTTONWIDTH);
            
        }else{
            _chooseView.frame = CGRectMake(_showEffectBtn.frame.origin.x, _showEffectBtn.frame.origin.y, 150, BUTTONWIDTH);
            modelBtn.frame = CGRectMake(BUTTONWIDTH + 15, 0, BUTTONWIDTH, BUTTONWIDTH);
            effectBtn.frame = CGRectMake((BUTTONWIDTH + 15) * 2, 0, BUTTONWIDTH, BUTTONWIDTH);
        }
        [self clipCornerRadius:BUTTONWIDTH / 2 withView:_chooseView];
        [self clipCornerRadius:BUTTONWIDTH / 2 withView:modelBtn];
        [self clipCornerRadius:BUTTONWIDTH / 2 withView:effectBtn];
        
        [modelBtn setBackgroundImage:[UIImage imageNamed:@"model"] forState:UIControlStateNormal];
        [effectBtn setBackgroundImage:[UIImage imageNamed:@"effect"] forState:UIControlStateNormal];
        
        [modelBtn addTarget:self action:@selector(showModel) forControlEvents:UIControlEventTouchUpInside];
        [effectBtn addTarget:self action:@selector(showEffect) forControlEvents:UIControlEventTouchUpInside];
        
        [_chooseView addSubview:modelBtn];
        [_chooseView addSubview:effectBtn];
    }
    
    
    return _chooseView;
}

#pragma make ---------- utils -----------

- (void)clipCornerRadius:(NSInteger)radius withView:(UIView *)view{
    view.layer.cornerRadius = radius;
    view.clipsToBounds = YES;
}

@end
