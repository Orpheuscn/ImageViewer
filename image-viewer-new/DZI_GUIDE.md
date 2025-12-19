# DZI 格式支持指南

## 什么是 DZI?

DZI (Deep Zoom Image) 是一种图像金字塔格式,专为超大图片的高性能查看而设计。它将大图片切分成多个层级的小瓦片,浏览器只需加载当前视口所需的瓦片,而不是整张图片。

### DZI 的优势

- ✅ **支持任意大小图片** - 即使是 GB 级别的图片也能流畅查看
- ✅ **即时加载** - 无需等待整张图片加载完成
- ✅ **内存友好** - 只加载可见区域,不占用大量内存
- ✅ **完美缩放** - 多级金字塔提供平滑的缩放体验

---

## 如何生成 DZI 文件

### 使用 vips (推荐)

vips 是一个高性能的图像处理库,可以快速生成 DZI 格式。

#### 1. 安装 vips

**macOS:**
```bash
brew install vips
```

**Ubuntu/Debian:**
```bash
sudo apt-get install libvips-tools
```

**Windows:**
从 [libvips 官网](https://www.libvips.org/install.html) 下载安装包

#### 2. 生成 DZI

```bash
# 基本用法
vips dzsave input.png output_dz

# 这会生成:
# output_dz.dzi          # DZI 描述文件
# output_dz_files/       # 瓦片文件夹
#   ├── 0/               # 第 0 层 (最小)
#   ├── 1/               # 第 1 层
#   ├── 2/               # 第 2 层
#   └── ...              # 更多层级
```

#### 3. 高级选项

```bash
# 指定瓦片大小 (默认 254)
vips dzsave input.png output_dz --tile-size 512

# 指定重叠像素 (默认 1)
vips dzsave input.png output_dz --overlap 2

# 指定输出格式
vips dzsave input.png output_dz --suffix .jpg[Q=90]

# 完整示例
vips dzsave huge_image.png huge_dz \
  --tile-size 256 \
  --overlap 1 \
  --suffix .jpg[Q=85]
```

---

## DZI 文件结构

生成的 DZI 文件夹结构如下:

```
huge_dz/
├── huge.dzi                    # DZI 描述文件 (XML)
└── huge_files/                 # 瓦片文件夹
    ├── vips-properties.xml     # vips 元数据 (可选)
    ├── 0/                      # 最低层级 (最小图片)
    │   └── 0_0.jpg
    ├── 1/
    │   ├── 0_0.jpg
    │   ├── 0_1.jpg
    │   ├── 1_0.jpg
    │   └── 1_1.jpg
    ├── 2/
    │   └── ...
    └── ...                     # 更多层级
```

### DZI 文件内容示例

`huge.dzi` 文件是一个 XML 文件:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Image xmlns="http://schemas.microsoft.com/deepzoom/2008"
       Format="jpg"
       Overlap="1"
       TileSize="256">
  <Size Width="32768" Height="24576"/>
</Image>
```

---

## 如何在图片查看器中使用 DZI

### 方法 1: 拖拽整个文件夹

1. 使用 vips 生成 DZI 文件
2. 打开图片查看器网页
3. **将整个 DZI 文件夹拖入浏览器窗口**
4. 查看器会自动检测 `.dzi` 文件并加载

### 方法 2: 拖拽多个 DZI 文件夹

如果你有多个 DZI 文件夹,可以:

1. 将它们放在同一个父文件夹中
2. 拖入父文件夹
3. 查看器会找到所有 `.dzi` 文件
4. 使用左右箭头在不同图片间切换

---

## 示例工作流程

### 处理超大 PNG 图片

假设你有一个 700MB 的 `huge.png` 文件:

```bash
# 1. 生成 DZI
vips dzsave huge.png huge_dz --tile-size 256 --suffix .jpg[Q=85]

# 2. 检查生成的文件
ls -lh huge_dz.dzi
ls -lh huge_dz_files/

# 3. 在浏览器中打开图片查看器
# 4. 拖入 huge_dz 文件夹 (包含 huge_dz.dzi 和 huge_dz_files/)
# 5. 享受流畅的查看体验!
```

### 批量处理多张图片

```bash
# 创建输出目录
mkdir dzi_output

# 批量转换
for img in *.png; do
  basename="${img%.png}"
  vips dzsave "$img" "dzi_output/${basename}_dz" --tile-size 256
done

# 拖入 dzi_output 文件夹到查看器
```

---

## 性能对比

| 方式 | 700MB PNG | 加载时间 | 内存占用 | 缩放性能 |
|------|-----------|----------|----------|----------|
| 直接加载 | ❌ 失败 | - | - | - |
| buildPyramid | ⚠️ 可能失败 | 30-60秒 | 2-4GB | 一般 |
| **DZI 格式** | ✅ 完美 | < 1秒 | < 200MB | 优秀 |

---

## 故障排除

### 问题 1: 拖入 DZI 文件夹后没有显示

**检查清单:**
- ✅ 确保文件夹包含 `.dzi` 文件
- ✅ 确保 `_files` 文件夹存在且包含瓦片
- ✅ 检查浏览器控制台是否有错误信息
- ✅ 确保拖入的是整个文件夹,不是单个文件

### 问题 2: 显示 "瓦片未找到" 警告

**可能原因:**
- DZI 文件和瓦片文件夹名称不匹配
- 瓦片文件夹结构不正确

**解决方案:**
确保文件夹结构符合标准:
```
name_dz.dzi
name_dz_files/
  ├── 0/
  ├── 1/
  └── ...
```

### 问题 3: vips 命令未找到

**解决方案:**
```bash
# macOS
brew install vips

# Ubuntu/Debian
sudo apt-get install libvips-tools

# 验证安装
vips --version
```

---

## 技术细节

### 图像金字塔层级计算

DZI 格式使用图像金字塔,每一层是上一层的一半大小:

```
层级 12: 32768 × 24576 (原始大小)
层级 11: 16384 × 12288
层级 10:  8192 ×  6144
...
层级  1:     2 ×     1
层级  0:     1 ×     1
```

### 瓦片命名规则

瓦片文件命名格式: `{level}/{column}_{row}.{format}`

例如:
- `0/0_0.jpg` - 第 0 层,第 0 列,第 0 行
- `5/3_2.jpg` - 第 5 层,第 3 列,第 2 行

---

## 推荐设置

### 照片类图片
```bash
vips dzsave photo.jpg photo_dz \
  --tile-size 256 \
  --overlap 1 \
  --suffix .jpg[Q=85]
```

### 扫描文档/艺术品
```bash
vips dzsave scan.tif scan_dz \
  --tile-size 512 \
  --overlap 2 \
  --suffix .jpg[Q=95]
```

### 截图/图表
```bash
vips dzsave screenshot.png screenshot_dz \
  --tile-size 256 \
  --overlap 1 \
  --suffix .png
```

---

## 更多资源

- [libvips 官方文档](https://www.libvips.org/)
- [OpenSeadragon 文档](https://openseadragon.github.io/)
- [Deep Zoom 格式规范](https://docs.microsoft.com/en-us/previous-versions/windows/silverlight/dotnet-windows-silverlight/cc645050(v=vs.95))

