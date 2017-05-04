module ApplicationHelper
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end

  def sklonjator(size, vopros, voprosa, voprosov)
    if size%100 >= 5 && size%100 <= 20
      voprosov

    elsif size%10 == 1
      vopros

    elsif size%10 >= 2 && size%10 <= 4
      voprosa

    else
      voprosov
    end
  end
end
