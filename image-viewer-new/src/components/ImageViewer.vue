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
        v-else-if="!currentImage && images.length === 0"
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
        <p class="text-base-content/50 text-sm mt-2">✨ 支持超大图片和大量文件</p>
      </div>

      <!-- Image Viewer -->
      <div v-if="currentImage" class="relative">
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
        </div>

        <!-- Close Button -->
        <button @click="closeViewer" class="btn btn-circle btn-sm absolute top-4 right-4">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>

        <!-- Navigation Buttons (for multiple images) -->
        <div v-if="images.length > 1" class="absolute top-1/2 left-4 right-4 flex justify-between transform -translate-y-1/2 pointer-events-none">
          <button @click="previousImage" :disabled="currentIndex === 0" class="btn btn-circle pointer-events-auto" :class="{ 'btn-disabled': currentIndex === 0 }">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          <button @click="nextImage" :disabled="currentIndex === images.length - 1" class="btn btn-circle pointer-events-auto" :class="{ 'btn-disabled': currentIndex === images.length - 1 }">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>
        </div>

        <!-- Image Info -->
        <div class="mt-4 text-center">
          <p class="text-lg font-semibold">{{ currentImage.name }}</p>
          <p v-if="images.length > 1" class="text-sm text-base-content/70">{{ currentIndex + 1 }} / {{ images.length }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick } from 'vue'
import OpenSeadragon from 'openseadragon'
import heic2any from 'heic2any'

const isDragging = ref(false)
const isLoading = ref(false)
const images = ref([])
const currentIndex = ref(0)
const currentImage = ref(null)
const viewerContainer = ref(null)
let viewer = null

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

  for (let i = 0; i < items.length; i++) {
    const item = items[i]
    if (item.kind === 'file') {
      const entry = item.webkitGetAsEntry()
      if (entry) {
        await traverseFileTree(entry, files)
      }
    }
  }

  if (files.length > 0) {
    // 处理所有图片文件,包括 HEIC 格式
    const processedFiles = []
    for (const file of files) {
      if (file.type.startsWith('image/')) {
        processedFiles.push(file)
      } else if (file.name.toLowerCase().endsWith('.heic') || file.name.toLowerCase().endsWith('.heif')) {
        // 转换 HEIC 格式
        try {
          const convertedBlob = await heic2any({
            blob: file,
            toType: 'image/jpeg',
            quality: 0.9
          })
          // 创建新的 File 对象
          const convertedFile = new File(
            [convertedBlob],
            file.name.replace(/\.heic$/i, '.jpg').replace(/\.heif$/i, '.jpg'),
            { type: 'image/jpeg' }
          )
          processedFiles.push(convertedFile)
        } catch (error) {
          console.error('HEIC 转换失败:', error)
        }
      }
    }

    images.value = processedFiles
    if (images.value.length > 0) {
      await loadImage(0)
    }
  }

  isLoading.value = false
}

const traverseFileTree = async (item, files) => {
  if (item.isFile) {
    return new Promise((resolve) => {
      item.file((file) => {
        files.push(file)
        resolve()
      })
    })
  } else if (item.isDirectory) {
    const dirReader = item.createReader()

    // readEntries() 每次最多返回 100 个条目,需要循环调用
    const readAllEntries = async () => {
      const allEntries = []

      const readBatch = () => {
        return new Promise((resolve) => {
          dirReader.readEntries(async (entries) => {
            if (entries.length > 0) {
              allEntries.push(...entries)
              // 继续读取下一批
              const moreEntries = await readBatch()
              resolve(moreEntries)
            } else {
              // 没有更多条目了
              resolve(allEntries)
            }
          })
        })
      }

      return await readBatch()
    }

    const entries = await readAllEntries()
    for (const entry of entries) {
      await traverseFileTree(entry, files)
    }
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
  currentIndex.value = 0
}

const previousImage = () => {
  if (currentIndex.value > 0) {
    loadImage(currentIndex.value - 1)
  }
}

const nextImage = () => {
  if (currentIndex.value < images.value.length - 1) {
    loadImage(currentIndex.value + 1)
  }
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
})
</script>
