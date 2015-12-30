package com.xzd.substation.util;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import com.xzd.substation.common.Constant;


/**
 *
 */
public class MailUtil
{
	// 定义发件人别名
	private static String displayName = Constant.MAIL_DISPLAY_NAME;

	//邮件发送者
	private static String from = Constant.MAIL_SENDER;

	//邮件服务器
	private static String smtpServer = Constant.MAIL_SMTP_SERVER;

	//用户名
	private static String username = Constant.MAIL_USER_NAME;

	//密码
	private static String password = Constant.MAIL_PASSWORD;

	//字符集
	private static String charset = Constant.MAIL_CHARSET;

	/**
	 * @param tos
	 *           发送地址
	 * @param isAuth
	 *           是否需要认证
	 * @param subject
	 *           主题
	 * @param content
	 *           内容
	 * @param isHtml
	 *           是否是html
	 * @param files
	 *           附件
	 * @throws MessagingException
	 * @throws UnsupportedEncodingException
	 */
	public static void send(final String[] tos, final boolean isAuth, final String subject, final String content, final boolean isHtml,
			final File[] files) throws MessagingException, UnsupportedEncodingException
	{
		Session session = null;
		final Properties props = System.getProperties();
		props.put("mail.smtp.host", smtpServer);
		if (isAuth)
		{ // 服务器需要身份认证
			props.put("mail.smtp.auth", "true");
			//生成认证的Authenticator
			final Authenticator authenticator = new Authenticator()
			{
				@Override
				protected javax.mail.PasswordAuthentication getPasswordAuthentication()
				{
					return new javax.mail.PasswordAuthentication(username, password);
				}
			};
			session = Session.getDefaultInstance(props, authenticator);
		}
		else
		{
			props.put("mail.smtp.auth", "false");
			session = Session.getDefaultInstance(props, null);
		}
		//是否debug
		session.setDebug(true);
		final Transport trans = session.getTransport("smtp");

		//多个接收人
		final InternetAddress[] address = new InternetAddress[tos.length];
		for (int i = 0; i < address.length; i++)
		{
			address[i] = new InternetAddress(tos[i]);
		}

		//连接服务器
		trans.connect(smtpServer, username, password);

		//生成发送的消息
		final Message msg = new MimeMessage(session);

		//邮件的地址及别名
		final Address from_address = new InternetAddress(from, displayName);

		//设置
		msg.setFrom(from_address);

		//设置接收人地址
		msg.setRecipients(Message.RecipientType.TO, address);

		//设置发送主题
		msg.setSubject(subject);

		//部件
		final Multipart mp = new MimeMultipart();

		//body部件
		MimeBodyPart mbp = new MimeBodyPart();

		//判断发送的是否是html格式
		if (isHtml)
		{// 如果是html格式
			mbp.setContent(content, "text/html;charset=" + charset);
		}
		else
		{
			mbp.setText(content);
		}
		//将该正文部件加入到整体部件
		mp.addBodyPart(mbp);

		if (files != null && files.length > 0)
		{// 判断是佛有附件
		 //存在附件就将附件全部加入到BodyPart
			for (final File file : files)
			{
				mbp = new MimeBodyPart();
				final FileDataSource fds = new FileDataSource(file); // 得到数据源
				mbp.setDataHandler(new DataHandler(fds)); // 得到附件本身并至入BodyPart
				mbp.setFileName(fds.getName()); // 得到文件名同样至入BodyPart
				mp.addBodyPart(mbp);
			}
		}
		// Multipart加入到信件
		msg.setContent(mp);

		// 设置信件头的发送日期
		msg.setSentDate(new Date());

		// 发送信件
		msg.saveChanges();

		//发送
		trans.sendMessage(msg, msg.getAllRecipients());

		//结束
		trans.close();

	}

	public static void main(final String[] args) throws UnsupportedEncodingException, MessagingException
	{
		MailUtil.send(new String[]
		{ "yuan496_01@163.com", "li.yuanyuan@uniclick.cn" }, false, "test", "<a href=\"www.baidu.com\">百度一下</a>", true, null);
	}
}
