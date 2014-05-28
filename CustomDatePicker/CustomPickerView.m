
#import "CustomPickerView.h"

#define ROW_HEIGHT 34

@interface CustomPickerView(PrivateMethods)
- (void)snap;
- (UIImage *)imageWithColor:(UIColor *)color forRect:(CGRect) rect;

@end

@implementation CustomPickerView

@synthesize tableView, strings, delegate;
@synthesize isSpinning = _isSpinning;
@synthesize selectedString = _selectedString;
@synthesize selectedIndex = _selectedIndex;
@synthesize verticalLabelOffset = _verticalLabelOffset;
@synthesize labelFontSize = _labelFontSize;
@synthesize data4Rows = _data4Rows;


- (id)initWithFrame:(CGRect)frame
         background:(UIImage*)backImage
itemVerticalOffset:(CGFloat)offset andData:(NSArray*) data
{
    CGRect rect;
    rect.origin.x = frame.origin.x;
    rect.origin.y = frame.origin.y;
    rect.size.width = backImage.size.width;
    rect.size.height = backImage.size.height;
    self.data4Rows = data;
    
    self = [super initWithFrame:rect];
    
    if (self)
    {
        self.verticalLabelOffset = offset;
        self.isSpinning = NO;
        isAnimating = NO;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(3, 3, rect.size.width-TABLE_RECT_OFFSET, rect.size.height-TABLE_RECT_OFFSET) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = ROW_HEIGHT;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor whiteColor];
        
        //[self addSubview:self.tableView]; // behind base image
        
        UIImageView *overlayView = [[UIImageView alloc] initWithImage:backImage];
        [overlayView setBackgroundColor:[UIColor clearColor]];
        [overlayView setUserInteractionEnabled:NO];
        overlayView.center = CGPointMake(rect.size.width/2, rect.size.height/2);
        //[self addSubview:overlayView]; //image should be particially transparent
       
        [self addSubview:self.tableView]; //on base image
        [self addSubview:overlayView];
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        [self snap];
    }
    return self;
}

- (void)dealloc
{
    self.customPickerViewControllerDidSpinCallback = nil;
    self.tableView = nil;
    self.data4Rows = nil;
    self.strings = nil;
}


- (void)setDataIndex:(NSUInteger)index
{
    int rowsCount = [self.tableView numberOfRowsInSection:0];
    _selectedIndex = index < rowsCount && index > 0 ? index : rowsCount;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = nil;
    if (section == 0)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* headerView = nil;
    if (section == 0)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 19)];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 20;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 19;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data4Rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellName = [NSString stringWithFormat:@"%d",indexPath.row];
    UITableViewCell *cell = (UITableViewCell *)[aTableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        NSString* dataObjectStr = [NSString stringWithFormat:@"%@",[self.data4Rows objectAtIndex:indexPath.row] ];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, ROW_HEIGHT)];
        [valueLabel setText:dataObjectStr];
        [valueLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.contentView addSubview:valueLabel];

    }
    
    return cell;
}

-(void)setData4Rows:(NSArray *)data4Rows
{
    //if (data4Rows!=_data4Rows)
   // {
        _data4Rows = data4Rows;
        [self.tableView reloadData];
        [self snap];
   // }
}

#pragma mark UIScrollViewDelegate methods

-(void)retrieveCustomPickerViewControllerDidSpinCallback:(CustomPickerViewControllerDidSpinCallback)callback
{
    self.customPickerViewControllerDidSpinCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.isSpinning = YES;
    [self.delegate pickerControllerDidSpin:self];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        self.isSpinning = NO;
        isAnimating = NO;
        [self snap];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isSpinning = NO;
    isAnimating = NO;
    [self snap];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (isAnimating)
    {
        isAnimating = NO;
        self.isSpinning = NO;
        [self.delegate pickerController:self didSnapToString:self.selectedString];
        if (self.customPickerViewControllerDidSpinCallback)
        {
            self.customPickerViewControllerDidSpinCallback(self.selectedIndex + 1);
        }

    }
    else
        [self snap];
}

- (void)snap
{
    if (isAnimating)
        return;
    
    isAnimating = YES;
    
    self.isSpinning = NO;
    
    double verticalPadding = (self.tableView.frame.size.height - self.tableView.rowHeight) * .5;
    
    for (int i=0; i<[[self.tableView visibleCells] count]; i++)
    {
        UITableViewCell *cell = [[self.tableView visibleCells] objectAtIndex:i];
        
        //UICustomPickerLabel *label = (UICustomPickerLabel *)[cell viewWithTag:kPickerLabelTag];
        
        BOOL selected = CGRectContainsPoint(CGRectMake(0, self.tableView.contentOffset.y + verticalPadding,
                                                       self.tableView.frame.size.width, self.tableView.rowHeight),cell.center);
        //[label setSelected:selected];
        
        if (selected)
        {
            isAnimating = YES;
            self.isSpinning = NO;
            
            [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            _selectedIndex = [self.tableView indexPathForCell:cell].row;
            if ([self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:cell]].origin.y == self.tableView.contentOffset.y + (self.tableView.frame.size.height - ROW_HEIGHT) * .5)
            {
                _selectedIndex = [self.tableView indexPathForCell:cell].row;
                [self.delegate pickerController:self didSnapToString:self.selectedString];
                isAnimating = NO;
            }
        }
    }
}

#pragma mark private methods

- (UIImage *)imageWithColor:(UIColor *)color forRect:(CGRect) rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}


@end
