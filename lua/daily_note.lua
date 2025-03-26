-- ~/.config/nvim/lua/daily_note.lua

local M = {}

-- today 명령어 설정 함수
function M.setup()
  vim.api.nvim_create_user_command('Today', function()
    -- 현재 날짜를 yyyy-MM-dd 형식으로 가져오기
    local current_date = os.date '%Y-%m-%d'

    -- 파일 경로 생성
    local file_path = vim.fn.expand('~/brain/daily/' .. current_date .. '.md')

    -- brain/daily 디렉토리가 존재하는지 확인하고 없으면 생성
    local dir_path = vim.fn.expand '~/brain/daily'
    if vim.fn.isdirectory(dir_path) == 0 then
      vim.fn.mkdir(dir_path, 'p')
    end

    -- 파일이 존재하는지 확인
    local file_exists = vim.fn.filereadable(file_path) == 1

    -- 현재 버퍼를 확인
    local current_bufnr = vim.api.nvim_get_current_buf()

    -- 새 버퍼를 만들고 파일 경로를 설정
    local bufnr = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(bufnr, file_path)

    -- 버퍼 타입을 비움
    vim.api.nvim_buf_set_option(bufnr, 'buftype', '')
    -- 수정 가능하게 설정
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
    -- 파일 타입 설정
    vim.api.nvim_buf_set_option(bufnr, 'filetype', 'markdown')

    -- 새 버퍼로 전환
    vim.api.nvim_set_current_buf(bufnr)

    -- 파일이 존재하지 않았다면 기본 템플릿 추가
    if not file_exists then
      local lines = {
        '# ' .. current_date,
        '',
        '## 오늘 할 일',
        '',
        '## 메모',
        '',
        '## 회고',
        '',
      }
      vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, lines)

      -- 변경사항 저장 시도
      pcall(function()
        vim.cmd 'write'
      end)
    else
      -- 파일이 존재한다면 내용 로드
      local file = io.open(file_path, 'r')
      if file then
        local content = {}
        for line in file:lines() do
          table.insert(content, line)
        end
        file:close()
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
      end
    end

    -- 성공 메시지 표시
    print('오늘의 일지가 준비되었습니다: ' .. file_path)
  end, {})
end

return M
