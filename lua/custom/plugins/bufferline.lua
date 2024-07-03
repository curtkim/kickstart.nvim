return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup {
      options = {
        indicator = {
          style = 'icon', -- 'underline',
        },
        offsets = {
          {
            filetype = 'neo-tree',
            text = '',
            text_align = 'center',
            separator = true,
          },
        },
      },
    }
  end,
}
