<template>
  <div class="min-h-screen bg-base-200 flex flex-col">
    <!-- Header -->
    <div class="navbar bg-base-100 shadow-lg">
      <div class="flex-1">
        <a class="btn btn-ghost text-xl">图片查看器</a>
      </div>
      <div class="flex-none">
        <label class="swap swap-rotate">
          <input type="checkbox" class="theme-controller" value="dark" @change="toggleTheme" />
          <svg class="swap-off fill-current w-6 h-6" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <path d="M5.64,17l-.71.71a1,1,0,0,0,0,1.41,1,1,0,0,0,1.41,0l.71-.71A1,1,0,0,0,5.64,17ZM5,12a1,1,0,0,0-1-1H3a1,1,0,0,0,0,2H4A1,1,0,0,0,5,12Zm7-7a1,1,0,0,0,1-1V3a1,1,0,0,0-2,0V4A1,1,0,0,0,12,5ZM5.64,7.05a1,1,0,0,0,.7.29,1,1,0,0,0,.71-.29,1,1,0,0,0,0-1.41l-.71-.71A1,1,0,0,0,4.93,6.34Zm12,.29a1,1,0,0,0,.7-.29l.71-.71a1,1,0,1,0-1.41-1.41L17,5.64a1,1,0,0,0,0,1.41A1,1,0,0,0,17.66,7.34ZM21,11H20a1,1,0,0,0,0,2h1a1,1,0,0,0,0-2Zm-9,8a1,1,0,0,0-1,1v1a1,1,0,0,0,2,0V20A1,1,0,0,0,12,19ZM18.36,17A1,1,0,0,0,17,18.36l.71.71a1,1,0,0,0,1.41,0,1,1,0,0,0,0-1.41ZM12,6.5A5.5,5.5,0,1,0,17.5,12,5.51,5.51,0,0,0,12,6.5Zm0,9A3.5,3.5,0,1,1,15.5,12,3.5,3.5,0,0,1,12,15.5Z"/>
          </svg>
          <svg class="swap-on fill-current w-6 h-6" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <path d="M21.64,13a1,1,0,0,0-1.05-.14,8.05,8.05,0,0,1-3.37.73A8.15,8.15,0,0,1,9.08,5.49a8.59,8.59,0,0,1,.25-2A1,1,0,0,0,8,2.36,10.14,10.14,0,1,0,22,14.05,1,1,0,0,0,21.64,13Zm-9.5,6.69A8.14,8.14,0,0,1,7.08,5.22v.27A10.15,10.15,0,0,0,17.22,15.63a9.79,9.79,0,0,0,2.1-.22A8.11,8.11,0,0,1,12.14,19.73Z"/>
          </svg>
        </label>
      </div>
    </div>

    <!-- Main Content -->
    <div class="flex-1 container mx-auto p-4">
      <!-- Loading Indicator -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center h-[70vh]">
        <span class="loading loading-spinner loading-lg text-primary"></span>
        <p class="mt-4 text-lg">正在处理图片...</p>
        <p class="mt-2 text-sm text-base-content/60">大文件夹或超大图片可能需要较长时间</p>
      </div>

      <!-- Drop Zone -->
      <div
        v-else-if="!currentImage && images.length === 0 && dziItems.length === 0"
        @drop.prevent="handleDrop"
        @dragover.prevent
        @dragenter.prevent="isDragging = true"
        @dragleave.prevent="isDragging = false"
        :class="['border-4 border-dashed rounded-lg p-12 text-center transition-all', isDragging ? 'border-primary bg-primary/10' : 'border-base-300']"
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="h-24 w-24 mx-auto mb-4 opacity-50" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
        </svg>
        <h2 class="text-2xl font-bold mb-2">拖拽图片或文件夹到这里</h2>
        <p class="text-base-content/70">支持单张图片或整个文件夹 (包括 HEIC/HEIF 格式)</p>
        <p class="text-base-content/50 text-sm mt-2">✨ 支持超大图片、大量文件和 DZI 格式</p>
        <p class="text-base-content/40 text-xs mt-1">💡 拖入 vips 生成的 DZI 文件夹可查看超大图片</p>
      </div>

      <!-- Image Viewer -->
      <div v-if="currentImage || dziItems.length > 0" class="relative">
        <!-- OpenSeadragon Container -->
        <div ref="viewerContainer" class="w-full h-[70vh] bg-black rounded-lg"></div>

        <!-- Controls -->
        <div class="absolute top-4 left-4 flex gap-2">
          <button @click="zoomIn" class="btn btn-circle btn-sm">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
          </button>
          <button @click="zoomOut" class="btn btn-circle btn-sm">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4" />
            </svg>
          </button>
          <button @click="resetView" class="btn btn-circle btn-sm">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
            </svg>
          </button>
          <button @click="toggleFullscreen" class="btn btn-circle btn-sm">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4" />
            </svg>
          </button>
          <!-- 缩略图按钮 - 只在非DZI模式且有多张图片时显示 -->
          <button v-if="!isDziMode && images.length > 1" @click="showThumbnails = !showThumbnails" class="btn btn-circle btn-sm" :class="{ 'btn-primary': showThumbnails }">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" />
            </svg>
          </button>
          <!-- 排序按钮 - 只在非DZI模式且有多张图片时显示 -->
          <button v-if="!isDziMode && images.length > 1" @click="toggleSort" class="btn btn-circle btn-sm" :title="sortBy === 'name' ? '按文件名排序' : '按拍摄时间排序'">
            <svg v-if="sortBy === 'name'" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h13M3 8h9m-9 4h6m4 0l4-4m0 0l4 4m-4-4v12" />
            </svg>
            <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </button>
        </div>

        <!-- Close Button -->
        <button @click="closeViewer" class="btn btn-circle btn-sm absolute top-4 right-4">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>

        <!-- Navigation Buttons (for multiple images) -->
        <div v-if="(isDziMode && dziItems.length > 1) || (!isDziMode && images.length > 1)" class="absolute top-1/2 left-4 right-4 flex justify-between transform -translate-y-1/2 pointer-events-none">
          <button @click="previousImage" :disabled="currentIndex === 0" class="btn btn-circle pointer-events-auto" :class="{ 'btn-disabled': currentIndex === 0 }">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          <button @click="nextImage" :disabled="currentIndex === (isDziMode ? dziItems.length - 1 : images.length - 1)" class="btn btn-circle pointer-events-auto" :class="{ 'btn-disabled': currentIndex === (isDziMode ? dziItems.length - 1 : images.length - 1) }">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>
        </div>

        <!-- Image Info -->
        <div class="mt-4 text-center">
          <p class="text-lg font-semibold">
            {{ isDziMode ? dziItems[currentIndex]?.name : currentImage?.name }}
            <span v-if="isDziMode" class="badge badge-primary ml-2">DZI</span>
          </p>
          <p v-if="(isDziMode && dziItems.length > 1) || (!isDziMode && images.length > 1)" class="text-sm text-base-content/70">
            {{ currentIndex + 1 }} / {{ isDziMode ? dziItems.length : images.length }}
          </p>
        </div>

        <!-- 缩略图网格视图 -->
        <div v-if="showThumbnails && !isDziMode && images.length > 1" class="mt-6 bg-base-100 rounded-lg p-4 shadow-lg">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-semibold">所有图片 ({{ images.length }})</h3>
            <button @click="showThumbnails = false" class="btn btn-sm btn-ghost">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-4 max-h-96 overflow-y-auto">
            <div
              v-for="(image, index) in images"
              :key="index"
              @click="jumpToImage(index)"
              class="cursor-pointer group relative aspect-square rounded-lg overflow-hidden border-2 transition-all hover:scale-105"
              :class="index === currentIndex ? 'border-primary shadow-lg' : 'border-base-300 hover:border-primary/50'"
            >
              <img
                :src="getThumbnailUrl(image)"
                :alt="image.name"
                class="w-full h-full object-cover"
                loading="lazy"
              />
              <div class="absolute inset-0 bg-black/0 group-hover:bg-black/30 transition-all flex items-center justify-center">
                <span class="text-white opacity-0 group-hover:opacity-100 text-xs font-semibold bg-black/50 px-2 py-1 rounded">
                  {{ index + 1 }}
                </span>
              </div>
              <!-- 当前图片指示器 -->
              <div v-if="index === currentIndex" class="absolute top-1 right-1">
                <div class="badge badge-primary badge-sm">当前</div>
              </div>
              <!-- 文件名提示 -->
              <div class="absolute bottom-0 left-0 right-0 bg-black/70 text-white text-xs p-1 truncate opacity-0 group-hover:opacity-100 transition-all">
                {{ image.name }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick } from 'vue'
import OpenSeadragon from 'openseadragon'
import heic2any from 'heic2any'
import exifr from 'exifr'

const isDragging = ref(false)
const isLoading = ref(false)
const images = ref([])
const currentIndex = ref(0)
const currentImage = ref(null)
const viewerContainer = ref(null)
let viewer = null

// DZI 支持
const dziItems = ref([])  // 存储 DZI 项目 { dziFile, filesMap, name }
const isDziMode = ref(false)  // 是否为 DZI 模式

// 缩略图视图
const showThumbnails = ref(false)  // 是否显示缩略图视图
const thumbnailUrlCache = new Map()  // 缓存缩略图 URL

// 排序选项
const sortBy = ref('name')  // 'name' 或 'date'
const imageMetadata = new Map()  // 存储图片的 EXIF 数据

const toggleTheme = (e) => {
  const html = document.documentElement
  if (e.target.checked) {
    html.setAttribute('data-theme', 'dark')
  } else {
    html.setAttribute('data-theme', 'light')
  }
}

const handleDrop = async (e) => {
  isDragging.value = false
  isLoading.value = true
  const items = e.dataTransfer.items
  const files = []

  console.log('开始遍历文件...')
  const startTime = Date.now()

  for (let i = 0; i < items.length; i++) {
    const item = items[i]
    if (item.kind === 'file') {
      const entry = item.webkitGetAsEntry()
      if (entry) {
        await traverseFileTree(entry, files)
      }
    }
  }

  const traverseTime = Date.now() - startTime
  console.log(`文件遍历完成! 耗时: ${traverseTime}ms, 文件数: ${files.length}`)

  if (files.length > 0) {
    // 首先检查是否有 DZI 文件
    const dziFiles = files.filter(f => f.name.toLowerCase().endsWith('.dzi'))

    if (dziFiles.length > 0) {
      // DZI 模式
      await processDziFiles(files, dziFiles)
    } else {
      // 普通图片模式
      await processRegularImages(files)
    }
  }

  isLoading.value = false
}

// 自然排序比较函数 - 正确处理文件名中的数字
const naturalCompare = (a, b) => {
  const ax = []
  const bx = []

  a.replace(/(\d+)|(\D+)/g, (_, num, str) => {
    ax.push([num || Infinity, str || ''])
  })
  b.replace(/(\d+)|(\D+)/g, (_, num, str) => {
    bx.push([num || Infinity, str || ''])
  })

  while (ax.length && bx.length) {
    const an = ax.shift()
    const bn = bx.shift()
    const nn = (an[0] - bn[0]) || an[1].localeCompare(bn[1])
    if (nn) return nn
  }

  return ax.length - bx.length
}

// 提取图片的 EXIF 数据
const extractExifData = async (file) => {
  try {
    const exif = await exifr.parse(file, {
      pick: ['DateTimeOriginal', 'CreateDate', 'DateTime', 'DateCreated']
    })
    if (exif) {
      // 优先使用 DateTimeOriginal (拍摄时间)
      const date = exif.DateTimeOriginal || exif.CreateDate || exif.DateTime || exif.DateCreated
      if (date) {
        imageMetadata.set(file, { captureDate: new Date(date) })
        console.log(`提取 EXIF: ${file.name} - ${date}`)
      }
    }
  } catch (error) {
    // 如果没有 EXIF 数据,使用文件的最后修改时间
    imageMetadata.set(file, { captureDate: new Date(file.lastModified) })
  }
}

// 排序图片
const sortImages = async (files) => {
  if (sortBy.value === 'name') {
    // 按文件名自然排序
    files.sort((a, b) => naturalCompare(a.name, b.name))
  } else if (sortBy.value === 'date') {
    // 等待所有 EXIF 数据提取完成
    await new Promise(resolve => setTimeout(resolve, 500))

    // 按拍摄时间排序
    files.sort((a, b) => {
      const dateA = imageMetadata.get(a)?.captureDate || new Date(a.lastModified)
      const dateB = imageMetadata.get(b)?.captureDate || new Date(b.lastModified)
      return dateA - dateB
    })
  }
}

// 处理普通图片
const processRegularImages = async (files) => {
  isDziMode.value = false
  const processedFiles = []
  imageMetadata.clear()

  for (const file of files) {
    if (file.type.startsWith('image/')) {
      processedFiles.push(file)
      // 异步提取 EXIF 数据
      extractExifData(file)
    } else if (file.name.toLowerCase().endsWith('.heic') || file.name.toLowerCase().endsWith('.heif')) {
      // 转换 HEIC 格式
      try {
        const convertedBlob = await heic2any({
          blob: file,
          toType: 'image/jpeg',
          quality: 0.9
        })
        const convertedFile = new File(
          [convertedBlob],
          file.name.replace(/\.heic$/i, '.jpg').replace(/\.heif$/i, '.jpg'),
          { type: 'image/jpeg' }
        )
        processedFiles.push(convertedFile)
        // 异步提取 EXIF 数据
        extractExifData(convertedFile)
      } catch (error) {
        console.error('HEIC 转换失败:', error)
      }
    }
  }

  // 按当前排序方式排序
  await sortImages(processedFiles)

  images.value = processedFiles
  if (images.value.length > 0) {
    await loadImage(0)
  }
}

// 处理 DZI 文件
const processDziFiles = async (allFiles, dziFiles) => {
  isDziMode.value = true
  dziItems.value = []

  console.log(`找到 ${dziFiles.length} 个 DZI 文件`)
  console.log(`总共 ${allFiles.length} 个文件`)

  for (const dziFile of dziFiles) {
    // 读取 DZI 文件内容
    const dziContent = await readFileAsText(dziFile)

    // 构建文件映射: 相对路径 -> File 对象
    const filesMap = new Map()
    const dziBaseName = dziFile.name.replace('.dzi', '')
    const dziPath = dziFile.webkitRelativePath || dziFile.name

    console.log(`处理 DZI: ${dziPath}`)
    console.log(`DZI 基础名称: ${dziBaseName}`)

    // 找到 DZI 文件所在的目录
    const dziDir = dziPath.includes('/') ? dziPath.substring(0, dziPath.lastIndexOf('/') + 1) : ''

    console.log(`DZI 目录: "${dziDir}"`)

    // 将所有文件按路径存储
    let tileCount = 0
    for (const file of allFiles) {
      const filePath = file.webkitRelativePath || file.name

      // 如果 DZI 在根目录,直接匹配;否则需要在同一目录下
      let relativePath = ''
      if (dziDir === '') {
        relativePath = filePath
      } else if (filePath.startsWith(dziDir)) {
        relativePath = filePath.substring(dziDir.length)
      } else {
        continue
      }

      filesMap.set(relativePath, file)

      // 统计瓦片文件
      if (relativePath.includes(`${dziBaseName}_files/`) &&
          (relativePath.endsWith('.jpg') || relativePath.endsWith('.jpeg') || relativePath.endsWith('.png'))) {
        tileCount++
      }
    }

    console.log(`文件映射大小: ${filesMap.size}`)
    console.log(`瓦片文件数量: ${tileCount}`)

    dziItems.value.push({
      dziFile,
      dziContent,
      filesMap,
      name: dziBaseName,
      basePath: dziDir
    })
  }

  if (dziItems.value.length > 0) {
    await loadDziImage(0)
  }
}

// 读取文件为文本
const readFileAsText = (file) => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = (e) => resolve(e.target.result)
    reader.onerror = reject
    reader.readAsText(file)
  })
}

const traverseFileTree = async (item, files, path = '') => {
  if (item.isFile) {
    return new Promise((resolve) => {
      item.file((file) => {
        // 保存相对路径信息
        const relativePath = path ? `${path}/${file.name}` : file.name
        Object.defineProperty(file, 'webkitRelativePath', {
          value: relativePath,
          writable: false
        })
        files.push(file)
        resolve()
      })
    })
  } else if (item.isDirectory) {
    const dirReader = item.createReader()
    const newPath = path ? `${path}/${item.name}` : item.name

    // readEntries() 每次最多返回 100 个条目,需要循环调用
    const readAllEntries = async () => {
      const allEntries = []

      const readBatch = async () => {
        return new Promise((resolve) => {
          dirReader.readEntries((entries) => {
            if (entries.length > 0) {
              allEntries.push(...entries)
              // 继续读取下一批
              resolve(false) // 返回 false 表示还有更多
            } else {
              // 没有更多条目了
              resolve(true) // 返回 true 表示完成
            }
          })
        })
      }

      // 循环读取直到没有更多条目
      let done = false
      while (!done) {
        done = await readBatch()
      }

      return allEntries
    }

    const entries = await readAllEntries()

    // 使用 Promise.all 确保所有子项都被处理
    await Promise.all(entries.map(entry => traverseFileTree(entry, files, newPath)))
  }
}

const loadImage = async (index) => {
  if (index >= 0 && index < images.value.length) {
    currentIndex.value = index
    currentImage.value = images.value[index]
    await nextTick()
    initViewer()
  }
}

const loadDziImage = async (index) => {
  if (index >= 0 && index < dziItems.value.length) {
    currentIndex.value = index
    await nextTick()
    initDziViewer(dziItems.value[index])
  }
}

const initViewer = () => {
  if (viewer) {
    viewer.destroy()
    viewer = null
  }

  if (currentImage.value && viewerContainer.value) {
    const imageUrl = URL.createObjectURL(currentImage.value)

    viewer = OpenSeadragon({
      element: viewerContainer.value,
      prefixUrl: 'https://cdnjs.cloudflare.com/ajax/libs/openseadragon/3.1.0/images/',
      tileSources: {
        type: 'image',
        url: imageUrl,
        buildPyramid: true,  // 启用客户端图像金字塔构建
        crossOriginPolicy: false
      },
      // 渲染器配置 - 优先使用 Canvas,对超大图片更稳定
      drawer: 'canvas',
      // 增加最大图片尺寸限制
      maxImageCacheCount: 200,
      timeout: 120000,  // 增加超时时间到 2 分钟
      // 内存和性能优化
      immediateRender: false,
      preload: false,
      // 显示配置
      showNavigator: true,
      navigatorPosition: 'BOTTOM_RIGHT',
      animationTime: 0.5,
      blendTime: 0.1,
      constrainDuringPan: true,
      maxZoomPixelRatio: 2,
      minZoomLevel: 0.5,
      visibilityRatio: 0.5,
      zoomPerScroll: 1.2,
      showNavigationControl: false,
      gestureSettingsMouse: {
        clickToZoom: true,
        dblClickToZoom: true
      }
    })

    // 添加错误处理
    viewer.addHandler('open-failed', (event) => {
      console.error('图片加载失败:', event)
      alert('图片加载失败,可能是图片太大或格式不支持。建议使用服务端预处理。')
    })
  }
}

const initDziViewer = (dziItem) => {
  if (viewer) {
    viewer.destroy()
    viewer = null
  }

  if (viewerContainer.value) {
    // 创建自定义 tile source
    const customTileSource = createCustomDziTileSource(dziItem)

    viewer = OpenSeadragon({
      element: viewerContainer.value,
      prefixUrl: 'https://cdnjs.cloudflare.com/ajax/libs/openseadragon/3.1.0/images/',
      tileSources: customTileSource,  // 直接传入对象,不需要数组
      // 显示配置
      showNavigator: true,
      navigatorPosition: 'BOTTOM_RIGHT',
      animationTime: 0.5,
      blendTime: 0.1,
      constrainDuringPan: true,
      maxZoomPixelRatio: 2,
      minZoomLevel: 0.5,
      visibilityRatio: 0.5,
      zoomPerScroll: 1.2,
      showNavigationControl: false,
      gestureSettingsMouse: {
        clickToZoom: true,
        dblClickToZoom: true
      }
    })

    viewer.addHandler('open-failed', (event) => {
      console.error('DZI 加载失败:', event)
      alert('DZI 图片加载失败,请检查文件夹结构是否完整。')
    })

    viewer.addHandler('tile-load-failed', (event) => {
      console.error('瓦片加载失败:', event)
    })
  }
}

// 创建自定义 DZI tile source
const createCustomDziTileSource = (dziItem) => {
  // 解析 DZI XML
  const parser = new DOMParser()
  const xmlDoc = parser.parseFromString(dziItem.dziContent, 'text/xml')
  const imageElement = xmlDoc.getElementsByTagName('Image')[0]
  const sizeElement = xmlDoc.getElementsByTagName('Size')[0]

  const tileSize = parseInt(imageElement.getAttribute('TileSize'))
  const overlap = parseInt(imageElement.getAttribute('Overlap'))
  const format = imageElement.getAttribute('Format')
  const width = parseInt(sizeElement.getAttribute('Width'))
  const height = parseInt(sizeElement.getAttribute('Height'))

  console.log('DZI 参数:', { tileSize, overlap, format, width, height })

  // 创建 URL 映射
  const tileUrlCache = new Map()
  const tilesFolder = `${dziItem.name}_files`

  console.log(`查找瓦片文件夹: ${tilesFolder}`)

  // 预处理所有瓦片文件,创建 blob URL
  let cachedTileCount = 0
  for (const [relativePath, file] of dziItem.filesMap.entries()) {
    if (relativePath.startsWith(tilesFolder) || relativePath.includes(`/${tilesFolder}/`)) {
      const url = URL.createObjectURL(file)
      // 标准化路径 - 移除可能的前缀
      let normalizedPath = relativePath
      if (relativePath.includes(`/${tilesFolder}/`)) {
        normalizedPath = relativePath.substring(relativePath.indexOf(`/${tilesFolder}/`) + 1)
      }
      tileUrlCache.set(normalizedPath, url)
      cachedTileCount++
    }
  }

  console.log(`缓存了 ${cachedTileCount} 个瓦片 URL`)

  // 打印前几个缓存的路径作为示例
  const samplePaths = Array.from(tileUrlCache.keys()).slice(0, 5)
  console.log('示例瓦片路径:', samplePaths)

  // 从缓存的瓦片中自动检测最大层级
  let maxLevel = 0
  for (const path of tileUrlCache.keys()) {
    const match = path.match(/(\d+)\/\d+_\d+\.\w+$/)
    if (match) {
      const level = parseInt(match[1])
      if (level > maxLevel) {
        maxLevel = level
      }
    }
  }
  console.log(`检测到的最大层级: ${maxLevel}`)

  // 使用 OpenSeadragon 的自定义 tile source 格式
  // 参考: https://openseadragon.github.io/examples/tilesource-custom/
  // 和 https://openseadragon.github.io/examples/advanced-data-model/
  return {
    height: height,
    width: width,
    tileSize: tileSize,
    tileOverlap: overlap,
    minLevel: 0,
    maxLevel: maxLevel,

    // 实现 getTileUrl 方法 - 返回唯一的 URL 用于缓存
    getTileUrl: function(level, x, y) {
      // 返回一个唯一的标识符,用于缓存键
      // 格式: blob://custom-dzi/level/x_y.format
      return `blob://custom-dzi/${level}/${x}_${y}.${format}`
    },

    // 实现 getTileHashKey 方法 - 生成缓存键
    // 这个方法用于生成瓦片的缓存键,必须唯一标识每个瓦片
    getTileHashKey: function(level, x, y, url) {
      return `${level}/${x}_${y}`
    },

    // 实现自定义下载逻辑
    downloadTileStart: function(imageJob) {
      const level = imageJob.tile.level
      const x = imageJob.tile.x
      const y = imageJob.tile.y

      console.log(`请求瓦片: level=${level}, x=${x}, y=${y}`)

      const tilePath = `${tilesFolder}/${level}/${x}_${y}.${format}`
      const blobUrl = tileUrlCache.get(tilePath)

      if (!blobUrl) {
        console.warn('瓦片未找到:', tilePath)
        // 调试:打印缓存中的所有键
        console.log('缓存中的键数量:', tileUrlCache.size)
        // 打印同一层级的所有瓦片
        const sameLevelKeys = Array.from(tileUrlCache.keys()).filter(k => k.includes(`/${level}/`))
        console.log(`层级 ${level} 的瓦片:`, sameLevelKeys.slice(0, 10))
        imageJob.finish(null, null, 'Tile not found')
        return
      }

      // 创建 Image 对象并加载 blob URL
      const image = new Image()

      image.onload = function() {
        imageJob.finish(image)
      }

      image.onerror = function() {
        console.error('瓦片加载失败:', tilePath)
        imageJob.finish(null, null, 'Image load failed')
      }

      image.src = blobUrl
    },

    // 实现下载中止方法
    downloadTileAbort: function(imageJob) {
      // Blob URL 加载无法中止,但我们需要提供这个方法
    }
  }
}

const zoomIn = () => {
  if (viewer) viewer.viewport.zoomBy(1.5)
}

const zoomOut = () => {
  if (viewer) viewer.viewport.zoomBy(0.5)
}

const resetView = () => {
  if (viewer) viewer.viewport.goHome()
}

const toggleFullscreen = () => {
  if (!document.fullscreenElement) {
    viewerContainer.value?.requestFullscreen()
  } else {
    document.exitFullscreen()
  }
}

const closeViewer = () => {
  if (viewer) {
    viewer.destroy()
    viewer = null
  }
  currentImage.value = null
  images.value = []
  dziItems.value = []
  isDziMode.value = false
  currentIndex.value = 0
  showThumbnails.value = false
  sortBy.value = 'name'
  // 清理缩略图 URL
  for (const url of thumbnailUrlCache.values()) {
    URL.revokeObjectURL(url)
  }
  thumbnailUrlCache.clear()
  imageMetadata.clear()
}

const previousImage = () => {
  if (currentIndex.value > 0) {
    if (isDziMode.value) {
      loadDziImage(currentIndex.value - 1)
    } else {
      loadImage(currentIndex.value - 1)
    }
  }
}

const nextImage = () => {
  const maxIndex = isDziMode.value ? dziItems.value.length - 1 : images.value.length - 1
  if (currentIndex.value < maxIndex) {
    if (isDziMode.value) {
      loadDziImage(currentIndex.value + 1)
    } else {
      loadImage(currentIndex.value + 1)
    }
  }
}

const jumpToImage = (index) => {
  if (index >= 0 && index < images.value.length) {
    loadImage(index)
    // 关闭缩略图视图
    showThumbnails.value = false
  }
}

// 获取缩略图 URL
const getThumbnailUrl = (file) => {
  if (!thumbnailUrlCache.has(file)) {
    const url = URL.createObjectURL(file)
    thumbnailUrlCache.set(file, url)
  }
  return thumbnailUrlCache.get(file)
}

// 切换排序方式
const toggleSort = async () => {
  if (isDziMode.value || images.value.length <= 1) return

  // 切换排序方式
  sortBy.value = sortBy.value === 'name' ? 'date' : 'name'

  // 保存当前图片
  const currentFile = currentImage.value

  // 重新排序
  const files = [...images.value]
  await sortImages(files)
  images.value = files

  // 找到当前图片的新索引
  const newIndex = images.value.findIndex(img => img === currentFile)
  if (newIndex !== -1) {
    currentIndex.value = newIndex
  }

  console.log(`排序方式切换为: ${sortBy.value === 'name' ? '文件名' : '拍摄时间'}`)
}

const handleKeyDown = (e) => {
  if (!currentImage.value) return

  if (e.key === 'ArrowLeft') {
    previousImage()
  } else if (e.key === 'ArrowRight') {
    nextImage()
  } else if (e.key === 'Escape') {
    closeViewer()
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeyDown)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeyDown)
  if (viewer) {
    viewer.destroy()
  }
  // 清理缩略图 URL
  for (const url of thumbnailUrlCache.values()) {
    URL.revokeObjectURL(url)
  }
  thumbnailUrlCache.clear()
})
</script>
